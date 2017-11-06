#!/bin/bash
set -e

init_db () {
    while [ ! -f /var/opt/mssql/log/errorlog ]; do
        echo "Waiting for the configuration to be finished"
        sleep 5
    done
    while ! cat /var/opt/mssql/log/errorlog | tr -d '\000' | grep -qw "SQL Server is now ready for client connections."; do
        echo "Waiting for the server to be started"
        sleep 5
    done
    echo started
    if ! grep -qw "NULL" <(sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -Q "SELECT (SCHEMA_ID('$MSSQL_DB'))"); then
        echo "Database '$MSSQL_DB' is initialized already"
        return
    fi

    echo "Initializing database '$MSSQL_DB'"
    SQL=$(cat <<SQL
CREATE DATABASE [$MSSQL_DB];
GO

ALTER DATABASE [$MSSQL_DB] SET DELAYED_DURABILITY = FORCED;
GO

CREATE LOGIN [$MSSQL_USER] WITH PASSWORD = '$MSSQL_PASSWORD', DEFAULT_DATABASE = [$MSSQL_DB], CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
GO

CREATE USER [$MSSQL_USER] FOR LOGIN [$MSSQL_USER];
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [$MSSQL_USER];
GO
SQL
)
    sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -Q "$SQL"
}

if [ $# -eq 0 ]; then
    /opt/mssql/bin/sqlservr & init_db
    exec tail -F /dev/null
else
    exec "$@"
fi
