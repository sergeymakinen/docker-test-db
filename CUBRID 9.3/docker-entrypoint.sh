#!/bin/bash
set -e

init_server () {
	if [ -f $CUBRID/conf/cubrid.conf ]; then
		if grep -qwe "^async_commit=yes" $CUBRID/conf/cubrid.conf; then
			echo "Server is initialized already"
			return
		fi
	else
		touch $CUBRID/conf/cubrid.conf
	fi

	echo "Initializing server"
    echo -e "async_commit=yes\ngroup_commit_interval_in_msecs=1000" >> $CUBRID/conf/cubrid.conf
}

init_db () {
	if [ -f $CUBRID_DATABASES/databases.txt ]; then
		if grep -qwe "^$CUBRID_DB" $CUBRID_DATABASES/databases.txt; then
			echo "Database '$CUBRID_DB' is initialized already"
			return
		fi
	else
		touch $CUBRID_DATABASES/databases.txt
	fi

	echo "Initializing database '$CUBRID_DB'"
    chown -R cubrid:cubrid $CUBRID_DATABASES
	if [ ! -d $CUBRID_DATABASES/$CUBRID_DB ]; then
		gosu cubrid mkdir -p $CUBRID_DATABASES/$CUBRID_DB
	fi
	cd $CUBRID_DATABASES/$CUBRID_DB
	gosu cubrid cubrid createdb --db-volume-size=$CUBRID_VOLUME_SIZE --server-name=localhost $CUBRID_DB $CUBRID_LOCALE
	if [ "$CUBRID_USER" -a "$CUBRID_USER" != "dba" -a "$CUBRID_USER" != "public" ]; then
		csql -u dba -S $CUBRID_DB -c "CREATE USER $CUBRID_USER PASSWORD '$CUBRID_PASSWORD';"
	fi
}

stop_db() {
   echo "Shutting down database '$CUBRID_DB'"
   gosu cubrid cubrid server stop $CUBRID_DB
   stopped=1
}

trap stop_db SIGTERM

if [ $# -eq 0 ]; then
	init_server && init_db && gosu cubrid cubrid broker start && gosu cubrid cubrid server start $CUBRID_DB
    while [ "$stopped" == '' ]; do
		sleep 1
	done
else
	exec "$@"
fi
