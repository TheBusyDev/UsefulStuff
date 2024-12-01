#!/bin/bash

count=0

while [ -f ~/Desktop/Launcher_$count.desktop ]
do
	count=$(( $count+1 ))
done

echo "[Desktop Entry]
Version=
Name=
Comment=
Exec=
Icon=
Terminal=false
Type=Application
Categories=Application;" > ~/Desktop/Launcher_$count.desktop

flatpak run org.gnome.TextEditor ~/Desktop/Launcher_$count.desktop

exit 0
