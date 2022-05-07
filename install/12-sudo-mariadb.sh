#!/usr/bin/env bash

. ./includes.sh

mysql_username=$(get_pwd mysql_username)
mysql_password=$(get_pwd mysql_password)

# install MariaDB
# https://www.systranbox.com/how-to-install-mariadb-on-oracle-linux/

curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
bash mariadb_repo_setup
dnf -y module reset mariadb
dnf -y install MariaDB-server MariaDB-client MariaDB-backup
systemctl enable --now mariadb

# mariadb-secure-installation
# https://lowendbox.com/blog/automating-mysql_secure_installation-in-mariadb-setup/

mysql -sfu root <<EOS
-- set root password and change authentication method (less secure)
ALTER USER '$mysql_username'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$mysql_password');

-- delete anonymous users
DELETE FROM mysql.user WHERE User='';

-- delete remote root capabilities
DELETE FROM mysql.user WHERE User='$mysql_username' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- drop database 'test'
DROP DATABASE IF EXISTS test;

-- also make sure there are lingering permissions to it
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- make changes immediately
FLUSH PRIVILEGES;
EOS
