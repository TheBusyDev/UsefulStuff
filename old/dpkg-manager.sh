#!/bin/bash

tput bold; tput setab 76; tput setaf 232
echo "                         "
echo "   DEB PACKAGE MANAGER   "
echo "                         "
tput sgr0

printf "\nType the command ([i]=install, [r]=remove) followed by the .deb package name:\n[command] [dpkg name]\n"
read cmd dpkg

if [ $cmd = "i" -o $cmd = "r" ]
then
	if [ $cmd = "i" ]
	then
		if [ -f /home/pietro/Downloads/$dpkg.deb ]
		then
			printf "\nWe will soon install your package!\n\n"
			sudo -v 
			gnome-terminal -- "/home/pietro/Documents/loading.sh" &
			sudo apt install /home/pietro/Downloads/$dpkg.deb
			sleep 1; pkill loading.sh

			tput bold
			printf "\n\n$dpkg installed correctly! Exiting"
			/home/pietro/Documents/3dots.sh
			tput sgr0
		else
			printf "\nWe're sorry, something goes wrong: the .deb package does not exist or is not placed in Downloads folder. Exiting"
			/home/pietro/Documents/3dots.sh
			exit
		fi
	fi

	if [ $cmd = "r" ]
	then 
		printf "\nWe will soon remove your package!\n\n"
		sudo -v 
		gnome-terminal -- "/home/pietro/Documents/loading.sh" &
		sudo apt remove $dpkg
		sleep 1; pkill loading.sh

		tput bold
		printf "\n\n$dpkg removed correctly! Exiting"
		/home/pietro/Documents/3dots.sh
		tput sgr0
	fi

else
	printf "\nWe're sorry, something goes wrong: the command was not valid. Exiting"
	/home/pietro/Documents/3dots.sh
	exit
fi

exit 0
