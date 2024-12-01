#!/bin/bash

cd /home/pietro/Documents/create-desktop-shortcut/
./create-desktop-shortcut-2.0.out
filename=$(cat .filename)

cd  $HOME/Desktop/
if [ -f ./"$filename".desktop ]
then
    chmod u+x ./"$filename".desktop
fi

exit 0