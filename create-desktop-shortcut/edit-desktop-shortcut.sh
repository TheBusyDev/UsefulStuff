#!/bin/bash
#edit .desktop files

echo "********************************"
echo "* This is my second script! :D *"
echo "********************************"

cd /home/pietro/Desktop/

printf "\nPlease, set the desired new values! If you don't want to change the value, just leave a blank space and press [ENTER]...\n"; sleep 0.5

printf "\nEnter old shortcut name:\n"
read filename



if [ "$(sed -n 4p $filename.desktop)" = 'Comment=f' -o "$(sed -n 4p $filename.desktop)" = 'Comment=e' ]
then
	if [ "$(sed -n 4p $filename.desktop)" = 'Comment=f' ]
	then
		printf "\nYou've selected a folder/file shortcut...\n"; sleep 0.5
		
		printf "\nEnter new shortcut name:\n"
		read newfilename
		
		printf "\nEnter new file/folder path:\n"
		read newpath
		
		printf "\nEnter new icon name/path:\n"
		read newicon
		
	else
		printf "\nYou've selected an exec/command shortcut...\n"; sleep 0.5
		
		printf "\nEnter new shortcut name:\n"
		read newfilename
		
		printf "\nEnter new exec path/command:\n"
		read newpath
		
		printf "\nEnter new icon name/path:\n"
		read newicon
		
		printf "\nSet new terminal value as true [true] or false [false]:\n"
		read newterminalvalue
	fi
else
	printf "\nSorry, I can't detect the shortcut type, exiting..."; sleep 2; exit 
fi



if [ "$newpath" != "" ]; then
	if [ "$(sed -n 4p $filename.desktop)" = 'Comment=f' ]
	then
		path="$(sed -n 5p $filename.desktop)"
		sed -i "s+$path+Exec=dolphin --new-window '$newpath'+" $filename.desktop
	else
		path="$(sed -n 5p $filename.desktop)"
		sed -i "s+$path+Exec='$newpath'+" $filename.desktop
		chmod +x "$newpath"
	fi
fi



if [ "$newicon" != "" ]; then
	icon="$(sed -n 6p $filename.desktop)"
	sed -i "s+$icon+Icon=$newicon+" $filename.desktop
fi



if [ "$newfilename" != "" ]
then
	mv $filename.desktop $newfilename.desktop
	oldname="$(sed -n 3p $newfilename.desktop)" 
	sed -i "s+$oldname+Name=$newfilename+" $newfilename.desktop
	
	if [ "$newterminalvalue" != "" ]; then
		if [ "$newterminalvalue" = "true" -o "$newterminalvalue" = "false" ]
		then
			terminalvalue="$(sed -n 7p $newfilename.desktop)"
			sed -i "s+$terminalvalue+Terminal=$newterminalvalue+" $newfilename.desktop
		else
			printf "\nSorry, we set all the new values except for the 'new terminal value' due to an error. Exiting...\n"; sleep 2; exit
		fi
	fi
else
	if [ "$newterminalvalue" != "" ]; then
		if [ "$newterminalvalue" = "true" -o "$newterminalvalue" = "false" ]
		then
			terminalvalue="$(sed -n 7p $filename.desktop)"
			sed -i "s+$terminalvalue+Terminal=$newterminalvalue+" $filename.desktop
		else
			printf "\nSorry, we set all the new values except for the 'new terminal value' due to an error. Exiting...\n"; sleep 2; exit
		fi
	fi
fi



printf "\nCool Pietro! Shortcut edited successfully! Please allow launching the shortcut!\n"
sleep 2; exit 0

