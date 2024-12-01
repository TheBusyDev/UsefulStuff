#!/bin/bash

link_addr='00:15:5d:fe:e6:97'

# WARNING - YOU NEED TO RESTART THE WSL TO ENABLE THE INTERNET CONNECTION
# needed to setup the license - it will disable any internet connection on WSL
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address $link_addr

opt="$1"

if [ "$opt" == "graphics" ]
then 
    tput setaf 14
    printf "\nStarting MATLAB graphic application...\n\n"
    tput sgr0
    matlab -sd "$PWD"
elif [ "$opt" == "" ]
then
    tput setaf 14
    printf "\nStarting MATLAB in $PWD...\n\n"
    matlab -nosplash -nodesktop -sd "$PWD"
    tput sgr0
else
    tput setaf 197
    echo "Only option accepted: 'graphics', to start a graphics environment..."
    tput sgr0
    
    exit 1
fi

exit 0