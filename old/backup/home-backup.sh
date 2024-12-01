#!/bin/bash

tput setab 82; tput setaf 16; tput bold
echo "                      "
echo "    SYSTEM BACKUP     "
echo "                      "
tput sgr0

printf "\n"

drive="notplugged"
while [ $drive = "notplugged" ]; do
	if [ -d /media/pietro/63D9-16F0/ ] #PATH OF BACKUP HARD-DRIVE
	then 
		drive="plugged"
	else 
		printf "\nPlease, plug your backup hard-drive and press [ENTER].\nIf you like to change your backup hard-drive, type [change]\nand follow the instructions:\n"
		read ans
		
		if [ "$ans" = "change" ]
		then
			tput setab 17; tput bold
			printf "\nPlug the hard-drive, open sys-backup.sh script and change the path on which the hard-drive is plugged in.\n"; sleep 3
			tput sgr0
		fi
	fi
done

SOURCEDIR=/home/
DESTINATIONDIR=/media/pietro/63D9-16F0
FILENAME=UBUNTU-BACKUP

if [ -f $DESTINATIONDIR/$FILENAME-*.tar.gz ]; then
	sudo mkdir $DESTINATIONDIR/temp-$FILENAME/
	cd $DESTINATIONDIR/
	sudo tar -xzf $FILENAME-*.tar.gz -C $DESTINATIONDIR/temp-$FILENAME/
	sudo rm $DESTINATIONDIR/$FILENAME-*.tar.gz
fi

sudo rsync --exclude=".*" --delete -a --no-links $SOURCEDIR $DESTINATIONDIR/temp-$FILENAME/

DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")
cd $DESTINATIONDIR/temp-$FILENAME/
sudo tar -czf $DESTINATIONDIR/$FILENAME-$DATE-$TIME.tar.gz *

sudo rm -rf $DESTINATIONDIR/temp-$FILENAME/

tput bold
printf "\n\n\nBackup completed successfully! Exiting..."
tput sgr0
sleep 5; exit 0

