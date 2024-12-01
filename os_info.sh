#!/bin/bash

os_version=$(lsb_release -r | awk {'print $2'})
ker_version=$(uname -r)

uptime=$(uptime --pretty)

if [ $(echo "$uptime" | grep -c hour) == "1" ]
then
    up_hours=$(echo "$uptime" | awk {'print $2'})
    up_mins=$(echo "$uptime" | awk {'print $4'})
else
    up_hours=0
    up_mins=$(echo "$uptime" | awk {'print $2'})
fi

shell=$(echo ${SHELL##*/})
shell_version=$($SHELL --version | awk {'print $2'})
free_ram=$(free --mega | grep Mem | awk {'print $3'})
total_ram=$(free --mega | grep Mem | awk {'print $2'})
perc=$(echo "scale=2; $free_ram*100/$total_ram" | bc)

printf "\n[0m[34m[1mOS[0m[0m:[0m Ubuntu $os_version[0m
[0m[34m[1mHost[0m[0m:[0m IdeaPad Gaming 3[0m
[0m[34m[1mKernel[0m[0m:[0m Linux $ker_version[0m
[0m[34m[1mUptime[0m[0m:[0m $up_hours hour(s), $up_mins min(s)[0m
[0m[34m[1mShell[0m[0m:[0m $shell $shell_version[0m
[0m[34m[1mCPU[0m[0m:[0m AMD Ryzen 5 4600H[0m
[0m[34m[1mMemory[0m[0m:[0m $free_ram MB / $total_ram MB $perc%%[0m
\n\n"

exit 0
