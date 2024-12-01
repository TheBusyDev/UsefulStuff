#!/bin/bash

ans="a"

while [ "$ans" = "a" ]
do
	/home/pietro/Documents/ookla-speedtest/speedtest
	
	printf "\nPress [ENTER] to exit or type [a] to try again\n"
	read ans
	
	if [ "$ans" != "" ] && [ "$ans" != "a" ]; then
		printf "\nError: wrong answer, exiting...\n"; sleep 2; exit
	fi
done

exit 0
