#!/usr/bin/env bash

pushd

timedatectl set-timezone Europe/Rome

dnf -y install vim
dnf -y install wget
dnf -y module install python39
dnf -y install python39-pip
dnf -y install perl
dnf -y install sqlite

popd
