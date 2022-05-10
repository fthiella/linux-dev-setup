@echo off
setlocal enableextensions

set target=gmt.mshome.net
set username=fede

:install

echo ---
echo Reset Fingerprint
echo ---
ssh-keygen -R %target%

echo ---
echo Remove Install directory if exists
echo ---
ssh %username%@%target% rm -rf install/

echo ---
echo Copy Install scripts
echo ---
scp -r install %username%@%target%:

echo ---
echo Set execute permissions
echo ---
ssh %username%@%target% chmod +x install/*.sh

:end