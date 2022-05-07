#!/bin/bash
set -o pipefail

SCRIPT_PATH=`readlink -f "$0"`
SCRIPT_DIR=`dirname "$SCRIPT_PATH"`

DIR=`date +%Y-%m-%d`
DEST=~/db_backups/$DIR

INPUT=$SCRIPT_DIR/db_list.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
{
    read
    while read -r system host username password db nothing
    do
	echo "system:   $system"
        echo "host:     $host"
        echo "username: $username"
        echo "password: $password"
        echo "db:       $db"

        # backup current db
        mkdir -p $DEST

	if [ $system == 'MYSQL' ]; then
            # status = 1, in progress

            echo 1 > $DEST/db_mysql_$host-$db-status.txt
            mysqldump -h $host -u $username -p"$password" $db | gzip > $DEST/db_mysql_$host-$db.sql.gz
            if [ "$?" -eq 0 ]; then
                echo 0,Completed > $DEST/db_mysql_$host-$db-status.txt
            else
                echo $?,Failed > $DEST/db_mysql_$host-$db-status.txt
            fi
        fi

	if [ $system == 'PGSQL' ]; then
	    echo 1 > $DEST/db_postgres_$host-$db-status.txt
	    PGPASSWORD=$password pg_dump --inserts --column-inserts --username=$username --host=$host --port=5432 $db | gzip > $DEST/db_postgres_$host-$db.sql.gz
	    if [ "$?" -eq 0 ]; then
	        echo 0,Completed > $DEST/db_postgres_$host-$db-status.txt
	    else
		echo $?,Failed > $DEST/db_postgres_$host-$db-status.txt
	    fi
	fi
    done
} < $INPUT
IFS=$OLDIFS
