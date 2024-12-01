#!/bin/bash

sudo snap refresh

n=5
while [ $n -gt 0 ]; do
	tput sc # sc = save cursor
	
	if [ $n != 1 ]
	then 
		printf "\nHowever, everything will explode in $n seconds\n"
	else
		printf "\nHowever, everything will explode in $n second\n"
	fi
	
	n=$(( $n - 1 ))
	sleep 1
	tput rc; tput ed # rc = restore cursor, ed = erase to end of screen
done

printf "\nHowever, everything will explode in 0 seconds\n"; sleep 1

/home/pietro/Documents/BOOM.sh

exit 0
