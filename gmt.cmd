@echo off
setlocal enableextensions

set mac=00-15-5d-08-a4-04
set username=fede

echo Getting IP for machine with MAC ADDRESS = %mac%

for /f "tokens=*" %%g in ('arp -a ^| findstr "%mac%" ^| awk "{ print $1}"') do (set ip=%%g)

echo IP: %ip%

if "%1"=="" goto :end
if "%1"=="install" goto :install

goto :error

:install
echo ---
echo Reset Fingerprint
echo ---
ssh-keygen -R %ip%


echo ---
echo Remove Install directory if exists
echo ---
ssh %username%@%ip% rm -rf install/

echo ---
echo Copy Install scripts
echo ---
scp -r install %username%@%ip%:

echo ---
echo Set execute permissions
echo ---
ssh %username%@%ip% chmod +x install/*.sh

goto :end

:error
echo Error!
goto :end

:end