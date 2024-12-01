#!/bin/bash

sleep 10
cd "$(dirname "$0")"

max_time=$((60*60*24*30)) # 60*60*24*30 == seconds per month
curr_date=$(date +%s)
latest_update=$(cat latest_update.txt)
latest_backup=$(cat latest_backup.txt)
update_icon="/home/pietro/Pictures/Icons/Reversal-blue/apps/scalable/AdobeUpdate.svg"
backup_icon="/home/pietro/Pictures/Icons/Reversal-blue/apps/scalable/timeshift.svg"

if [ $(($curr_date - $latest_update)) -ge $max_time ]
then
	notify-send -i $update_icon -u critical "Update Notifier" "It's time to update! :)"
fi

if [ $(($curr_date - $latest_backup)) -ge $max_time ]
then
	notify-send -i $backup_icon -u critical "Backup Notifier" "Don't forget your monthly backup! :)"
fi

exit 0
