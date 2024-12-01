#!/bin/bash

tput setab 82; tput setaf 16; tput bold
echo "                                 "
echo "    SHARED-MEMORY BACKUP 2.0     "
echo "                                 "
tput sgr0

SOURCEDIR=/media/pietro/Shared-Memory/
DESTINATIONDIR="$(cat /home/pietro/Documents/backup/.DESTINATIONDIR)"  #PATH OF BACKUP

if [ ! -d $SOURCEDIR ]; then
	/home/pietro/Documents/shared-memory.sh
fi

printf "\n"

drive="notplugged"
while [ $drive = "notplugged" ]; do
	if [ -d "$DESTINATIONDIR"/ ]
	then 
		drive="plugged"
	else 
		printf "\nPlease, plug your backup hard-drive and press [ENTER].\nIf you like to change your backup directory,\ntype [change] and follow the instructions:\n"
		read ans
		
		if [ "$ans" = "change" ]
		then
			tput setab 17; tput bold
			printf "\nType the new backup directory in the following document (without the last slash)\n"
			sleep 1

			i=0
			while [ $i -lt 5 ]
			do
				printf "."
				i=$(( $i + 1 ))
				sleep 1
			done
			tput sgr0

			nano /home/pietro/Documents/backup/.DESTINATIONDIR
			exit 0
		fi
	fi
done

gnome-terminal -- "/home/pietro/Documents/loading.sh" & #loading bar

unison $SOURCEDIR "$DESTINATIONDIR"/Shared-Memory/ -batch -fat -prefer $SOURCEDIR

pkill loading.sh

tput bold
printf "\n\n\nBackup completed successfully! Exiting"; 3dots
tput sgr0
read ans

exit 0
