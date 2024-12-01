#!/bin/bash

dir="${1:-"$PWD"}"

if [ ! -d "$dir" ]
then
    tput setaf 197
    echo "Directory '$dir' does not exist..."
    tput sgr0
    
    exit 1
fi

tput setaf 14
printf "\nStarting MATLAB in $dir...\n\n"
matlab -nosplash -nodesktop -sd "$dir"
tput sgr0

exit 0
