#!/bin/bash

printf "\n\nAre you sure to remove all screenshots [y/n]?\n"
read ans

if [ "$ans" = "y" -o "$ans" = "Y" ]
then
    rm /home/pietro/Pictures/Screenshot*.png
    printf "\n\nAll screenshots from 'Pictures' folder have been deleted!\nExiting"
    3dots
elif [ "$ans" = "n" -o "$ans" = "N" ]
then
    printf "\n\nExiting"
    3dots
else
    printf "\n\nError: wrong answer. Exiting"
    3dots
fi

exit 0
