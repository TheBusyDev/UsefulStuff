#!/bin/bash
#create .desktop files

echo "*********************************"
echo "** This is my first script! :D **"
echo "*********************************"

printf "\nEnter the shortcut name please:\n"
read filename

cp /home/pietro/Documents/create-desktop-shortcut/desktop-shortcut-example.txt /home/pietro/Desktop/

cd /home/pietro/Desktop/
mv desktop-shortcut-example.txt $filename.desktop #rename the file pasted in Desktop

#start editing the content of $filename.desktop
sed -i "s+Name=+Name=$filename+" $filename.desktop

printf "\nDo you want to create a shortcut of a folder/file [f] or of an executable/script/program, etc [e]?\n"
read answer

sed -i "s+Comment=+Comment=$answer+" $filename.desktop

if [ "$answer" = "f" -o "$answer" = "e" ]
then
	if [ "$answer" = "f" ]
	then 
		printf "\nEnter file/folder path:\n"
		read path
		sed -i "s+Exec=+Exec=dolphin --new-window '$path'+" $filename.desktop
		
		printf "\nEnter icon name/path:\n"
		read icon
		sed -i "s+Icon=+Icon=$icon+" $filename.desktop
		
		sed -i "s+Terminal=+Terminal=false+" $filename.desktop
		
	else
		printf "\nEnter exec path/command:\n"
		read path
		chmod +x "$path"
		sed -i "s+Exec=+Exec='$path'+" $filename.desktop
		
		printf "\nEnter icon name/path:\n"
		read icon
		sed -i "s+Icon=+Icon=$icon+" $filename.desktop
		
		printf "\nDo you want to set terminal value as true [true] or false [false]?\n"
		read terminalvalue
		
		if [ "$terminalvalue" = "true" -o "$terminalvalue" = "false" ]
		then
			sed -i "s+Terminal=+Terminal=$terminalvalue+" $filename.desktop
		
		else
			rm $filename.desktop
			printf "\nError: wrong answer, exiting...\n"; sleep 2; exit
		fi
	fi

else 
	rm $filename.desktop
	printf "\nError: wrong answer, exiting...\n"; sleep 2; exit
fi

printf "\nCool Pietro! Shortcut created successfully! Please allow launching the shortcut!\n"
sleep 2; exit 0

