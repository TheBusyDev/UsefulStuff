#!/bin/bash

tput bold; tput setab 76; tput setaf 232
echo "                          "
echo "      CLAM ANTIVIRUS      "
echo "                          "
tput sgr0

tput bold 
printf "\nWelcome to CLAM ANTIVURUS!\nType [s] to scan the internal storage.\nType [f] to scan a particular file or folder.\nType [c] to check logs (and virus infections).\n"
tput sgr0 
read ans1

case $ans1 in
s | f)    
    case $ans1 in
    s)
        DATE=$(date +"%Y%m%d")
        TIME=$(date +"%H%M%S")

        cd /home/pietro/Documents/clamav/
        if [ ! -f .counter ]
        then
            touch .counter
            printf "0" > .counter
        fi

        n=$(cat .counter)
        if [ $n = 10 ]; then n=0; fi

        m=$(( $n + 1 ))
        printf "$m" > .counter

        printf "\n"
        sudo freshclam

        cd /home/pietro/clamscan/
        if [ -f *-$m.txt ]; then rm *-$m.txt; fi
        clamscan --follow-file-symlinks=0 --follow-dir-symlinks=0 --detect-pua=yes --bell --log=./clamscan-$DATE-$TIME-$m.txt -i -r /
        ;;
    f)
        tput bold 
        printf "\nType the file/folder you like to scan: "
        tput sgr0 
        read "dir"

        if [ -f "$dir" ] || [ -d "$dir" ]
        then
            DATE=$(date +"%Y%m%d")
            TIME=$(date +"%H%M%S")

            cd /home/pietro/Documents/clamav/
            if [ ! -f .counter ]
            then
                touch .counter
                printf "0" >> .counter
            fi

            n=$(cat .counter)
            if [ $n = 10 ]; then n=0; fi

            m=$(( $n + 1 ))
            printf "$m" > .counter

            printf "\n"
            sudo freshclam

            cd /home/pietro/clamscan/
            if [ -f *-$m.txt ]; then rm *-$m.txt; fi
            clamscan --detect-pua=yes --bell --log=./clamscan-$DATE-$TIME-$m.txt -i -r "$dir"
        else
            tput bold 
            printf "\nError: the directory does not exist. Exiting"; 3dots
            tput sgr0 
            exit
        fi 
        ;;
    esac

    tput bold
    printf "\nScan completed successfully!\nIf you like to check logs (and virus infections), type [c].\nTo quit terminal, just press [ENTER].\n"
    tput sgr0 
    read ans2

    tput bold
    case $ans2 in
    c) 
        ranger ./
        ;;
    "")
        printf "\nExiting"; 3dots
        ;;
    *)
        printf "\nError: wrong answer!! Exiting"; 3dots 
        ;;
    esac
    tput sgr0
    ;;
c)
    ranger /home/pietro/clamscan/
    ;;
*)
    tput bold 
    printf "\nError: wrong answer!! Exiting"; 3dots 
    tput sgr0 
    ;;
esac

exit 0