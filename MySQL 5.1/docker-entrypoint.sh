#!/bin/bash
set -e

init_server () {
    if [ -d $MYSQL_DATABASES/mysql ]; then
        echo "Server is initialized already"
        return
    fi

    echo "Initializing server"
    gosu mysql mysql_install_db --datadir=$MYSQL_DATABASES --basedir=$MYSQL
}

init_db () {
    if [ -d $MYSQL_DATABASES/$MYSQL_DB ]; then
        echo "Database '$MYSQL_DB' is initialized already"
        return
    fi
    
    echo "Initializing database '$MYSQL_DB'"
    chown -R mysql:mysql $MYSQL_DATABASES
    while [ ! -S /tmp/mysql.sock ]; do
        echo "Waiting for the server to be started"
        sleep 5
    done
    SQL=$(cat <<SQL
CREATE DATABASE \`$MYSQL_DB\`;

CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

GRANT ALL ON \`$MYSQL_DB\`.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
SQL
)
    echo "$SQL" | mysql -S /tmp/mysql.sock -u root
}

stop_db() {
   echo "Shutting down database '$MYSQL_DB'"
   mysqladmin -S /tmp/mysql.sock -u root shutdown
   stopped=1
}

trap stop_db SIGTERM

if [ $# -eq 0 ]; then
    init_server && gosu mysql mysqld --datadir=$MYSQL_DATABASES --basedir=$MYSQL --language=$MYSQL/share/mysql/english --socket=/tmp/mysql.sock --pid-file=/tmp/mysql.pid --innodb-flush-log-at-trx-commit=0 --innodb-support-xa=0  --default-storage-engine=InnoDB & init_db
    while [ "$stopped" == '' ]; do
        sleep 1
    done
else
    exec "$@"
fi
