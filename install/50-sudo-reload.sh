#!/usr/bin/env bash

systemctl reload firewalld
systemctl enable php-fpm
systemctl enable nginx
systemctl start php-fpm
systemctl start nginx

systemctl enable mariadb
systemctl start mariadb
