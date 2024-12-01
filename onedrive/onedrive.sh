#!/bin/bash

if [ ! -d /media/pietro/Shared-Memory/ ]
then
	/home/pietro/Documents/shared-memory.sh
fi

DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")

cd /home/pietro/Documents/onedrive/

if [ ! -f .counter ]
then
    touch .counter
    printf "0" > .counter
fi

n=$(cat .counter)
if [ $n = 10 ]; then n=0; fi

n=$(( $n + 1 ))
printf "$n" > .counter

cd /home/pietro/onedrive/
if [ -f *-$n.log ]; then rm *-$n.log; fi

notify-send --app-name='ONEDRIVE SYNC' --icon=/home/pietro/Pictures/Icons/onedrive/logo-onedrive.png 'Starting OneDrive sync...'

onedrive --synchronize > onedrive-sync-$DATE-$TIME-$n.log

sample=$(cat /home/pietro/Documents/onedrive/sample.log)
sample_noconnection=$(cat /home/pietro/Documents/onedrive/sample-noconnection.log)
sample_logout=$(cat /home/pietro/Documents/onedrive/sample-logout.log)

sync=$(cat onedrive-sync-$DATE-$TIME-$n.log)

errors=$(( $(grep -ci "skip" onedrive-sync-$DATE-$TIME-$n.log) - 1 ))

if [  "$sync" == "$sample" ]
then
    text="Nothing to synchronize since the last backup!"

elif [ "$sync" == "$sample_noconnection" ]
then
    text="Error occurred: no internet connection :("

elif [ "$sync" == "$sample_logout" ]
then
    text="Plz run 'onedrive --logout' on terminal!"
    
elif [ "$errors" != "0" ]
then
    text="$errors error(s) occured: plz check the log :("
    
else
    text="OneDrive Sync completed successfully!"
fi

notify-send --app-name='ONEDRIVE SYNC' --icon=/home/pietro/Pictures/Icons/onedrive/logo-onedrive.png --expire-time=0 "$text"

if [ "$errors" != "0" ]
then
    gedit "onedrive-sync-$DATE-$TIME-$n.log"
fi

exit 0