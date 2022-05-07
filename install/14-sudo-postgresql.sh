#!/usr/bin/env bash

. ./includes.sh

postgres_username=$(get_pwd postgres_username)
postgres_password=$(get_pwd postgres_password)

postgres_hba=/var/lib/pgsql/14/data/pg_hba.conf

# install Postgresql
# https://www.postgresql.org/download/linux/redhat/

dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf -qy module disable postgresql
dnf install -y postgresql14-server
/usr/pgsql-14/bin/postgresql-14-setup initdb

systemctl enable postgresql-14
systemctl start postgresql-14

sudo -u postgres psql -c "ALTER USER $postgres_username PASSWORD '$postgres_password';"

header_string="TYPE  DATABASE        USER            ADDRESS                 METHOD"
add_string="local   all             postgres                                md5"

sed -i "/# $header_string/a $add_string" $postgres_hba

systemctl restart postgresql-14
