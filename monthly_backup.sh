#!/bin/bash

# select backup device
BCK_DEVICE="/run/media/pietro/BACKUP EXT4"

tput setaf 82; tput bold
printf '\n      TIMESHIFT - MONTHLY BACKUP      \n\n'
tput sgr0 

# check if hard-disk is plugged in
while [ ! -d "$BCK_DEVICE" ]
do
	tput setaf 160; tput bold
	printf "Backup device not plugged in...\nInsert it and then press [ENTER] to continue...\n"
	tput sgr0
	read ans
	printf "\n"
done

# perform backup
sudo timeshift --create

# print current date to 'latest_backup.txt'
cd $(dirname "$0")
curr_date=$(date +%s)
printf $curr_date > latest_backup.txt

tput bold
printf '\n\nPress [ENTER] to exit...\n'
tput sgr0
read ans

exit 0
