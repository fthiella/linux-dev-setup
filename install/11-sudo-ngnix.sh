#!/usr/bin/env bash

# install nginx, php and databases modules for php

# https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-centos-8
dnf -y install nginx
dnf -y install php-fpm
dnf -y install php-mysqlnd
dnf -y install php-pgsql
dnf -y install php-sqlite3

# configure firewall
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
