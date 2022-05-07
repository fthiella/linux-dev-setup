#!/usr/bin/env bash

. ./includes.sh

cp -r scripts ~/
chmod +x ~/scripts/*.sh

add_crontab "0 6,12 * * *" "~/scripts/db_backup.sh"
