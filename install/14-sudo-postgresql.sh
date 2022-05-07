#!/usr/bin/env bash

pushd

postgres_username=(`grep postgres_username password | awk '{print $2}'`)
postgres_password=(`grep postgres_password password | awk '{print $2}'`)

# install Postgresql
# https://www.postgresql.org/download/linux/redhat/

dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf -qy module disable postgresql
dnf install -y postgresql14-server
/usr/pgsql-14/bin/postgresql-14-setup initdb

systemctl enable postgresql-14
systemctl start postgresql-14

postgresql-setup --initdb

sudo -u postgres psql -c "ALTER USER $postgres_username PASSWORD '$postgres_password';"
sed -i '/# TYPE  DATABASE        USER            ADDRESS                 METHOD/a local   all             postgres                                md5' /var/lib/pgsql/14/data/pg_hba.conf

systemctl restart postgresql-14

popd
