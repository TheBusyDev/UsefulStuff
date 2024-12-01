#!/bin/bash

printf "\nSir, as You requested, I will print ANSI colors, from 0 to 255.\n[tput setab]='set at background'; [tput setaf]='set at foreground'\n\n"
sleep 0.5

i=0; n=51

for i in $(seq 0 255)
do
	if [ $i = 0 ]; then printf "	 "; fi
	if [ $i = 7 -o $i = 15 ]; then tput setaf 232; fi
	for l in $(seq $(( $n - 17 )) $n); do if [ $i = $l ]; then tput setaf 232; fi; done
	
	if [ $i = 124 ]; then tput cuu 21; fi
	for h in $(seq 124 6 231); do if [ $i = $h ]; then printf "					"; fi; done
	for g in $(seq 232 6 250); do if [ $i = $g ]; then printf "		      "; fi; done
	
	tput setab $i
	if [ $i -le 15 -o $i -ge 100 ]; then printf " $i "; fi
	if [ $i -ge 16 ] && [ $i -le 99 ]; then printf " $i  "; fi
	tput sgr0
	
	for j in $(seq 15 6 255); do if [ $i = $j ]; then printf "\n   "; fi; done
	for k in $(seq 15 36 255); do if [ $i = $k ]; then printf "\n   "; fi; done
	
	if [ $i = $n ]; then n=$(( $n + 36 )); fi
done

printf "\nPress [ENTER] to exit\n"
read ans

if [ "$ans" != "" ]; then 
	printf "\nError: wrong answer, exiting...\n"; sleep 2
fi

exit 0

