#!/bin/bash

if [ -d /media/pietro/Shared-Memory/ ]; then 
	gnome-terminal -- /bin/bash -c 'unison /home/pietro/Documents/ /media/pietro/Shared-Memory/Linux-Docs/ -batch -fat -links true -prefer /home/pietro/Documents/; sleep 3' &
fi

n=0
m1=0; m2=50
l={1.00..25.00..1.00}; l1=0; l2=0; l3=0; l4=0

while [ $n -lt 100 ]
do
	tput sc
	printf "\nRebooting $n%%"
	
	for j1 in $l; do if [ $l1 = $j1 ]; then printf "."; fi; done
	for j2 in $l; do if [ $l2 = $j2 ]; then printf ".."; fi; done
	for j3 in $l; do if [ $l3 = $j3 ]; then printf "..."; fi; done
	for j4 in $l; do if [ $l4 = $j4 ]; then printf "...."; fi; done
	
	printf "\nProgress ["
	tput setab 9; for i in $(seq $m1); do printf "#"; done; tput sgr0
	for k in $(seq $m2); do printf "-"; done
	printf "] "
	
	for j5 in $l; do if [ $l1 = $j5 ]; then printf "/"; fi; done
	for j6 in $l; do if [ $l2 = $j6 ]; then printf "-"; fi; done
	for j7 in $l; do if [ $l3 = $j7 ]; then printf "\\"; fi; done
	for j8 in $l; do if [ $l4 = $j8 ]; then printf "|"; fi; done
	printf "\n"
	
	n=$(( $n + 1 ))
	m1=$(( $n / 2 ))
	m2=$(( 50 - $m1 ))
	l1=$( echo "scale=2; ( $n + 3 ) / 4" | bc )
	l2=$( echo "scale=2; ( $n + 2 ) / 4" | bc )
	l3=$( echo "scale=2; ( $n + 1 ) / 4" | bc )
	l4=$( echo "scale=2; $n / 4" | bc )
	
	sleep 0.1; tput rc; tput ed
done

printf "\nRebooting $n%%....\nProgress ["
tput setab 9; for i in $(seq $m1); do printf "#"; done; tput sgr0
printf "]\n\n"; sleep 1

if [ -d /media/pietro/Shared-Memory/ ]; then udisksctl unmount -b /dev/nvme0n1p4; fi && if [ -d /media/pietro/Windows-SSD/ ]; then udisksctl unmount -b /dev/nvme0n1p3; fi

sleep 5; reboot; exit 0