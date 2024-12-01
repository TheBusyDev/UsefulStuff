#!/bin/bash

tput bold; tput setab 76; tput setaf 232
echo "                         "
echo "       APT MANAGER       "
echo "                         "
tput sgr0

printf "\nType the command ([i]=install, [r]=remove) followed by the package name:\n[command] [package name]\n"
read cmd package

if [ $cmd = "i" -o $cmd = "r" ]
then
	if [ $cmd = "i" ]
	then
		printf "\nWe will soon install your package!\n\n"
		sudo -v 
		gnome-terminal -- "/home/pietro/Documents/loading.sh" &
		sudo apt install $package
		sleep 1; pkill loading.sh
	else
		printf "\nWe will soon remove your package!\n\n"
		sudo -v 
		gnome-terminal -- "/home/pietro/Documents/loading.sh" &
		sudo apt remove $package && sudo apt purge $package && sudo apt autoremove $package
		sleep 1; pkill loading.sh
	fi

else
	printf "\nWe're sorry, something goes wrong: the command was not valid. Exiting" 
	/home/pietro/Documents/3dots.sh
	exit
fi

sleep 3; exit 0
