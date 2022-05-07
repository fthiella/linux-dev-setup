#!/usr/bin/env bash

add_crontab() {
	local cronjob="$1"
	local croncmd="$2"

	(( crontab -l || : ) | grep -v -F "$croncmd" ; echo "$cronjob $croncmd" ) | crontab -

}

cp -r scripts ~/
chmod +x ~/scripts/*.sh

add_crontab "0 6,12 * * *" "~/scripts/db_backup.sh"
