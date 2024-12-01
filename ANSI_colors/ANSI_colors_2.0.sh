#!/bin/bash

clear

printf "\nSir, as You requested, I will print ANSI colors, from 0 to 255.\n[tput setab]='set at background'; [tput setaf]='set at foreground'\n\n"
sleep 0.5

i=0; n=15; j=21; k=57

while [ $i -le 255 ]
do
	if [ $i = 0 ]; then printf "       "; fi
	if [ $i = 7 -o $i = 15 -o $i -ge 244 ]; then tput setaf 232; fi
	if [ $n -gt 15 ]
	then
		for h in $(seq $(( $n - 53 )) $(( $n - 36 ))); do if [ $i = $h ]; then tput setaf 232; fi; done
		for l in $(seq $(( $n - 17 )) $n); do if [ $i = $l ]; then tput setaf 232; fi; done
	fi
	
	tput setab $i
	if [ $i -le 15 -o $i -ge 100 ]; then printf " $i "; fi
	if [ $i -ge 16 ] && [ $i -le 99 ]; then printf " $i  "; fi
	tput sgr0
	
	if [ $i -lt $n ] && [ $i -lt 232 ]
	then
		if [ $i = $j ]; then printf "  "; j=$(( $j + 6 )); i=$(( $i + 30 )); fi
		if [ $i = $k ]; then printf "\n   "; k=$(( $k + 6 )); i=$(( $i - 36 )); fi
	fi
	
	if [ $i = $n ]
	then
		printf "\n\n   "
		n=$(( $n + 72 ))
		if [ $i != 15 ]; then j=$(( $j + 36 )); k=$(( $k + 42 )); fi
	fi
	
	if [ $i = 231 ]; then printf " "; fi
	if [ $i = 243 ]; then printf "\n    "; fi
	
	i=$(( $i + 1 ))
done

printf "\n\nPress [ENTER] to exit\n"
read ans
printf "\n\n"

exit 0
