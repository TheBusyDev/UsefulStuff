#!/bin/bash

tput setaf 82; tput bold
printf '\n      SYSTEM UPDATE      \n\n'
tput sgr0 

# perform update
sudo dnf update && sudo dnf autoremove -y && sudo flatpak update

if [ $? != 0 ]
then
	tput setaf 1; tput bold
	printf '\n\nAn error occured while updating...\nPress any key to exit! :(\n'
	tput sgr0 
	read -n1 ans
	exit 1
fi

# print current date to 'latest_update.txt'
cd $(dirname "$0")
curr_date=$(date +%s)
printf $curr_date > latest_update.txt

tput bold
printf '\n\nUpdate completed!\nWould you like to reboot now? [y/n] '
tput sgr0
read -n1 ans

printf '\n\n'

if [ "$ans" == "y" ] || [ "$ans" == "Y" ]
then
	tput bold
	printf 'Rebooting in'
	
	for ((i=3; i>=0; i--))
	do
		sleep 1
		printf " $i"
	done
	
	tput sgr0
	sleep 1
	reboot
	
elif [ "$ans" == "n" ] || [ "$ans" == "N" ]
then
	tput bold
	printf 'AS YOU PREFER...'
	tput sgr0
	sleep 3
	
else
	tput bold
	printf 'ARE U KIDDING ME??\n'
	tput sgr0
	sleep 3
fi

exit 0
