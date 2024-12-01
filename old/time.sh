#!/bin/bash

printf "\nInternet connection requested to run this script...\n\n"

sudo systemctl start systemd-timesyncd

printf "\nTime set correctly!\n"

sleep 2; exit 0
