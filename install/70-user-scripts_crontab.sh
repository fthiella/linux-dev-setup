#!/usr/bin/env bash

. ./includes.sh

mysql_username=$(get_pwd mysql_username)
mysql_password=$(get_pwd mysql_password)

postgres_username=$(get_pwd postgres_username)
postgres_password=$(get_pwd postgres_password)


cp -r scripts ~/
cat > scripts/db_list.csv <<EOF
system,host,username,password,db,
MYSQL,localhost,$mysql_username,$mysql_password,mysql,
PGSQL,localhost,$postgres_username,$postgres_password,postgres,
EOF

chmod +x ~/scripts/*.sh

add_crontab "0 6,12 * * *" "~/scripts/db_backup.sh"
