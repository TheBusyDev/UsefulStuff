#!/bin/bash

flameshot full -p /home/pietro/Pictures/ 
sleep 0.1 
play /usr/share/sounds/freedesktop/stereo/screen-capture.oga &
notify-send --app-name='FLAMESHOT' --icon=flameshot 'Screenshot took successfully!'

exit 0