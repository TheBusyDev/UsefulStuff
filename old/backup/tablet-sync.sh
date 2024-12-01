#!/bin/bash

tput setab 82; tput setaf 16; tput bold
echo "                            "
echo "        TABLET SYNC         "
echo "                            "
tput sgr0

printf "\n"

sd="notplugged"
while [ $sd = "notplugged" ]; do
	if [ -d /media/pietro/4A88-1500/ ]
	then 
		sd="plugged"
	else 
		printf "\nSD not connected! Please plug SD in and press [ENTER]\n"
		read ans
	fi
done

gnome-terminal -- "/home/pietro/Documents/loading.sh" & #loading bar

unison tablet-sync

pkill loading.sh

tput bold
printf "\n\n\nSD Sync completed successfully! Exiting"; 3dots
tput sgr0
read ans

exit 0
