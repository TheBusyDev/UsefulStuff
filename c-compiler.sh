#!/bin/bash

if [ ! -d /mnt/c/ ] #this implies you are in a Linux OS
then
    tput setaf 82; tput bold
    printf "\n     C-COMPILER 4 LINUX      \n"
    tput sgr0  
else
    tput setaf 82; tput bold
    printf "\n     C-COMPILER 4 WIN      \n"
    tput sgr0    
fi

l=0; m=""
while [ "$m" != 0 ]
do
    tput bold
    printf "\nType the .c program you want to run\n"
    if [ $l = 2 ]; then printf "or leave a blank space to execute the previous program\n"; fi
    printf "or type [c] to create a .c file\n"
    if [ "$m" != "clear" ] && [ $l != 0 ]; then printf "or type [clear] to clear the terminal\n"; fi
    printf "or type [0] to quit the compiler:\n"
    tput sgr0
    
    read "m"

    if [ "$m" != 0 ]
    then
        if [ "$m" = "clear" ] 
        then
            clear
            if [ $l = 1 ]; then l=0; fi

        elif [ "$m" = "c" ]
        then
            while true
            do
                tput bold; printf "\nType the filename: "; tput sgr0
                read file_name

                if [ ! -f ./"$file_name".c ]
                then
                    break
                else
                    tput setaf 197; tput bold
                    printf "\nA file named like this already exists...\n"
                    tput sgr0
                fi
            done

            touch "$file_name".c
            printf "/*\n\n*/\n#include <stdio.h>\n\nint main ()\n{\n\t\n\t\n\treturn 0;\n}" > "$file_name".c            

        else
            if [ "$m" != "" ]; then n="$m"; fi
        
            if [ -f ./"$n".c ]
            then
                printf "\n\n\n"
                gcc -o .tmp-"$n".out "$n".c -lm && tput setaf 118 && ./.tmp-"$n".out
                for file in ./.tmp*.out; do rm "$file"; done
                tput sgr0 
                printf "\n\n\n"
                l=2
            else
                tput setaf 197; tput bold
                printf "\nSorry, I can't find any file named like this...\n"
                tput sgr0
                l=1
            fi
        fi
    fi
done

printf "\n\n\n"

exit 0