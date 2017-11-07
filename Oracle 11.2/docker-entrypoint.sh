#!/bin/bash
set -e

init_server() {
    if [ ! -d $(dirname $ORACLE_HOME) ]; then
        rm -rf $(dirname $ORACLE_HOME)
        mkdir -p $(dirname $ORACLE_HOME)
        ln -fsT $ORACLE_PRODUCT $ORACLE_HOME
    fi
}

start_db() {
    if [ -d $ORACLE_BASE/oradata ]; then
        echo "Database '$ORACLE_DB' is initialized already"
        if [ ! -f /etc/oratab ]; then
               echo "XE:$ORACLE_HOME:N" > /etc/oratab
            chown oracle:dba /etc/oratab
            chmod 664 /etc/oratab
        fi
        if [ ! -f /etc/default/oracle-xe ]; then
            echo -e "ORACLE_DBENABLED=true\nLISTENER_PORT=1521\nHTTP_PORT=8080\nCONFIGURE_RUN=true" > /etc/default/oracle-xe
        fi
        rm -f $ORACLE_PRODUCT/dbs
        ln -fsT $ORACLE_BASE/dbs $ORACLE_PRODUCT/dbs
        /etc/init.d/oracle-xe start
        return
    fi

    echo "Initializing database '$ORACLE_DB'"
    rm -f $ORACLE_PRODUCT/dbs
    mkdir -p $ORACLE_BASE/dbs
    ln -fsT $ORACLE_BASE/dbs $ORACLE_PRODUCT/dbs
    chown -R oracle:dba $ORACLE_BASE
    echo -e "8080\n1521\noracle\noracle\ny\n" | /etc/init.d/oracle-xe configure
    SQL=$(cat <<EOF
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

ALTER USER "SYSTEM" ACCOUNT UNLOCK;

ALTER USER "SYSTEM" IDENTIFIED BY "oracle";

CREATE USER "$ORACLE_USER" IDENTIFIED BY "$ORACLE_PASSWORD" DEFAULT TABLESPACE "USERS";

GRANT CREATE SESSION, CONNECT, RESOURCE, DBA TO "$ORACLE_USER";

GRANT UNLIMITED TABLESPACE TO "$ORACLE_USER";
EOF
)
    gosu oracle bash -c "echo \"$SQL\" | sqlplus -S / as sysdba"
    if [ $ORACLE_DB != $ORACLE_USER ]; then
        SQL=$(cat <<EOF
CREATE USER "$ORACLE_DB" IDENTIFIED BY "$ORACLE_DB";

BEGIN
   FOR table_row IN (SELECT table_name FROM all_tables WHERE owner = '$ORACLE_DB') LOOP
      EXECUTE IMMEDIATE 'GRANT ALL ON $ORACLE_DB.' || table_row.table_name || ' TO $ORACLE_USER';
   END LOOP;
END;
EOF
)
        gosu oracle bash -c "echo \"$SQL\" | sqlplus -S / as sysdba"
    fi
}

stop_db() {
   echo "Shutting down database '$ORACLE_DB'"
   /etc/init.d/oracle-xe stop
   stopped=1
}

trap stop_db SIGTERM

if [ $# -eq 0 ]; then
    init_server && start_db
    while [ "$stopped" == '' ]; do
        sleep 1
    done
else
    exec "$@"
fi
