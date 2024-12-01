#!/bin/bash

tput setab 82; tput setaf 16; tput bold
echo "                        "
echo "    HOME BACKUP 2.0     "
echo "                        "
tput sgr0

SOURCEDIR=/home/pietro/
DESTINATIONDIR="$(cat /home/pietro/Documents/backup/.DESTINATIONDIR)"   #PATH OF BACKUP
FILENAME=UBUNTU-HOME
DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")

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

if [ ! -f "$DESTINATIONDIR"/.counter-$FILENAME ]
then
    cp /home/pietro/Documents/backup/.counter "$DESTINATIONDIR"/
    mv "$DESTINATIONDIR"/.counter "$DESTINATIONDIR"/.counter-$FILENAME
fi

n=$(sed -n 1p "$DESTINATIONDIR"/.counter-$FILENAME)
m=$(( $n + 1 ))
if [ $m != 10 ]
then
	sed -i "s/$n/$m/" "$DESTINATIONDIR"/.counter-$FILENAME
else
	sed -i "s/$n/0/" "$DESTINATIONDIR"/.counter-$FILENAME
	sudo rm "$DESTINATIONDIR"/.snapshot-$FILENAME
	sudo rm "$DESTINATIONDIR"/$FILENAME-*.tar
fi

printf "\n"

if [ -f "$DESTINATIONDIR"/$FILENAME-*.tar ]; then
	sudo mv "$DESTINATIONDIR"/$FILENAME-*.tar "$DESTINATIONDIR"/$FILENAME-$DATE-$TIME.tar
	
	cd $SOURCEDIR
	sudo tar --exclude='.cache' --listed-incremental="$DESTINATIONDIR"/.snapshot-$FILENAME -cvf "$DESTINATIONDIR"/.tmp-$FILENAME.tar *

	cd "$DESTINATIONDIR"/
	sudo tar --concatenate --file="./$FILENAME-$DATE-$TIME.tar" "./.tmp-$FILENAME.tar"
	sudo rm ./.tmp-$FILENAME.tar
else
	tput bold
	printf "\nThese will be a l"; sleep 0.5
	j=0
	while [ $j -lt 3 ]
	do
		printf "o"
		j=$(( $j + 1 ))
		sleep 0.5
	done
	printf "ng backup"; sleep 0.5
	k=0
	while [ $k -lt 3 ]
	do
		printf "."
		k=$(( $k + 1 ))
		sleep 0.5
	done
	tput sgr0

	cd $SOURCEDIR
	sudo tar --exclude='.cache' --listed-incremental="$DESTINATIONDIR"/.snapshot-$FILENAME -cvf "$DESTINATIONDIR"/$FILENAME-$DATE-$TIME.tar *
fi

tput bold
printf "\n\n\nBackup completed successfully! Exiting"; 3dots
tput sgr0
read ans

exit 0
