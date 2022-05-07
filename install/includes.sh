#!/usr/bin/env bash

set -uxo pipefail

get_pwd() {
	# no spaces or special characters allowed in key
	local key="$1"
	grep $key password | awk '{print $2}' 
}

add_crontab() {
	local cronjob="$1"
	local croncmd="$2"

	(( crontab -l 2>/dev/null || : ) | grep -v -F "$croncmd" ; echo "$cronjob $croncmd" ) | crontab -
}
