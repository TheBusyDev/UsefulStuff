#!/bin/bash

printf "\nPlease type the command ([cp]=copy, [mv]=move, [rm]=remove) and the exec name you want to add to Ubuntu Applications or remove from Ubutu Applications:\n[command] [exec name]\n"
read cmd filename

if [ "$cmd" = "cp" -o "$cmd" = "mv" -o "$cmd" = "rm" ]
then
	if [ "$cmd" = "cp" -o "$cmd" = "mv" ]
	then
		if [ -f /home/pietro/Desktop/$filename.desktop ]
		then
			$cmd /home/pietro/Desktop/$filename.desktop /home/pietro/.local/share/applications/$filename.desktop

			if [ -f /home/pietro/.local/share/applications/$filename.desktop ]
			then
				printf "\nCool Pietro! Everything worked fine!\n"; sleep 2; exit 0
			else
				printf "\nError: something did not work, exiting...\n"; sleep 2; exit
			fi
		else
			printf "\nWe're sorry, something goes wrong: the exec does not exist. Exiting...\n"; sleep 2; exit
		fi
	fi
	
	
	if [ "$cmd" = "rm" ] && [ -f /home/pietro/.local/share/applications/$filename.desktop ]
	then
		$cmd /home/pietro/.local/share/applications/$filename.desktop
		printf "\nCool Pietro! Everything worked fine!\n"; sleep 2; exit 0
	else
		printf "\nWe're sorry, something goes wrong: the exec does not exist. Exiting...\n"; sleep 2; exit
	fi
	
else
	printf "\nWe're sorry, something goes wrong: the command was not valid. Exiting...\n"; sleep 2; exit
fi

exit 0

