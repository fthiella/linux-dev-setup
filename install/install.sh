#!/usr/bin/env bash

pushd "$(dirname ${BASH_SOURCE:0})"
trap popd EXIT

sudo_password=(`grep sudo_password password | awk '{print $2}'`)

for file in ./*.sh
do
	if [[ $file == *"-sudo-"* ]]; then
		echo "---"
		echo "Executing SUDO $file"
		echo "---"
		echo $sudo_password | eval sudo -S $file
	elif [[ $file == *"-user-"* ]]; then
		echo "---"
		echo "Executing $file"
		echo "---"
		eval $file
	else
		echo skipping $file
	fi
done
