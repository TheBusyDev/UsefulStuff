#!/bin/bash

if [ -d /media/pietro/Shared-Memory/ ]; then 
	gnome-terminal -- /bin/bash -c 'unison /home/pietro/Documents/ /media/pietro/Shared-Memory/Linux-Docs/ -batch -fat -links true -prefer /home/pietro/Documents/; sleep 3' &
fi

printf "\n"

n=5
while [ $n -gt 0 ]; do
	tput sc # sc = save cursor
	
	if [ $n != 1 ]
	then
		printf "Self-destruction in $n seconds\n"
	else
		printf "Self-destruction in $n second\n"
	fi
	
	n=$(( $n - 1 )); sleep 1
	tput rc; tput ed # rc = restore cursor, ed = erase to end of line
done


n=5
while [ $n -gt 0 ]; do
	tput sc
	printf "Self-destruction in 0 seconds\nWARNING!\n"
	n=$(( $n - 1 )); sleep 0.5
	tput rc; tput ed; sleep 0.5
done

printf "Self-destruction in 0 seconds\nWARNING!\n\n"; sleep 1
printf "BOOM!\n"; sleep 0.1


if [ -d /media/pietro/Shared-Memory/ ]; then udisksctl unmount -b /dev/nvme0n1p4; fi && if [ -d /media/pietro/Windows-SSD/ ]; then udisksctl unmount -b /dev/nvme0n1p3; fi

sleep 5; shutdown -P now; exit 0
