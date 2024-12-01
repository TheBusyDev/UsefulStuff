#!/bin/bash

h=$(date +%H)
d=$(date +%u)

if [ $d = 1 ] && [ $h = 07 -o $h = 08 ]; then c=20
elif [ $d = 1 ] && [ $h = 09 -o $h = 10 ]; then c=10

elif [ $d = 2 ] && [ $h = 09 -o $h = 10 ]; then c=11
elif [ $d = 2 ] && [ $h = 12 -o $h = 13 ]; then c=31
elif [ $d = 2 ] && [ $h = 15 -o $h = 16 ]
then
    tput setaf 197
    printf "\nFisica - lezioni [l] o esercitazioni [e]?\n"
    read ans
    if [ "$ans" = "l" ]; then c=20
    elif [ "$ans" = "e" ]; then c=21
    else printf "\nWrong answer!\n"; c=0; sleep 3; fi
    tput sgr0

elif [ $d = 3 ] && [ $h = 13 -o $h = 14 ]; then c=21
elif [ $d = 3 ] && [ $h = 15 -o $h = 16 ]; then c=11

elif [ $d = 4 ] && [ $h = 08 -o $h = 09 ]; then c=10
elif [ $d = 4 ] && [ $h = 10 -o $h = 11 ]; then c=20

elif [ $d = 5 ] && [ $h = 08 -o $h = 09 ]; then c=10
elif [ $d = 5 ] && [ $h = 10 -o $h = 11 ]
then
    tput setaf 197
    printf "\nFisica - lezioni [l] o esercitazioni [e]?\n"
    read ans
    if [ "$ans" = "l" ]; then c=20
    elif [ "$ans" = "e" ]; then c=21
    else printf "\nWrong answer!\n"; c=0; sleep 3; fi
    tput sgr0
elif [ $d = 5 ] && [ $h = 14 -o $h = 15 ]; then c=30

elif [ $d = 6 ]
then 
    tput setaf 197
    printf "\nIt's Saturday, bitch!!\n"
    tput sgr0
    c=0
    sleep 3

elif [ $d = 7 ]
then
    tput setaf 197
    printf "\nIt's Sunday, bitch!!\n"
    tput sgr0
    c=0
    sleep 3

else
    tput setaf 197
    printf "\nThere is no lesson scheduled now"; 3dots; printf "\n"
    tput sgr0
    c=0
fi

printf "$c" > .course

exit 0
