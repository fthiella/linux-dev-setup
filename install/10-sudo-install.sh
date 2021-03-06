#!/usr/bin/env bash

# set Italian timezone
timedatectl set-timezone Europe/Rome

# install basic tools
dnf -y install vim
dnf -y install wget

# install gcc
dnf -y install gcc

# install python 3.9 and pip

dnf -y module install python39
dnf -y install python39-pip
pip3.9 install flask
pip3.9 install gunicorn

# install perl

dnf -y install perl
dnf -y install perl-App-cpanminus
dnf -y install perl-DBD-mysql
dnf -y install perl-DBD-Pg
dnf -y install perl-DBD-SQLite
cpanm Sql::Textify

# install sqlite

dnf -y install sqlite
