#!/bin/bash

printf "\n\033[1mThis is the working directory: \033[1;36m$PWD\033[0m\033[1m\nType a new directory to change it,\notherwise leave a blank space...\033[0m\n"
read "dir"

printf "\n"

if [ "$dir" != "" ]
then
    if [ -d "$dir" ]
    then
        cd "$dir"
    else
        printf "\033[0;31mError: directory does not exist. Exiting"
        3dots
        printf "\033[0m\n\n"
        exit 0
    fi
fi

for file in *.heif
do
    heif-convert -q 100 $file ${file%.*}.jpg && rm $file
done

for file in *.heic
do
    heif-convert -q 100 $file ${file%.*}.jpg && rm $file
done

printf "\n"

exit 0
