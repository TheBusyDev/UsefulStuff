#!/bin/bash

tput bold; tput setab 76; tput setaf 232
echo "                            "
echo "   CPUPOWER - CPU SCALING   "
echo "                            "
tput sgr0

gov[0]=powersave
gov[1]=conservative
gov[2]=schedutil
gov[3]=ondemand
gov[4]=performance
curr_gov=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor)
loop=1

while [ $loop != 0 ]
do
    if [ $loop = 1 -o $loop = 3 ]
    then
        tput bold
        total_freq=0
        for ((i=0; i<=11; i++))
        do
            total_freq=$(( $total_freq + $(cat /sys/devices/system/cpu/cpufreq/policy$i/scaling_cur_freq) ))
        done
        curr_freq=$( echo "scale=6; $total_freq/(12*1000000)" | bc )
        cpu_perc=$( echo "scale=2; $curr_freq*100/3" | bc )
        printf "\nCPU running at $curr_freq GHz (usage: $cpu_perc %%)\nGovernor set on $curr_gov...\n"
        tput sgr0
    fi
    
    printf "\nWhich CPU governor would you like to set?\n"
    
    if [ $loop = 1 ]
    then
        for ((i=0; i<=4; i++))
        do
            echo "[$i]=${gov[$i]}"
        done
        echo "[p]=print CPU info"
        printf "[q]=quit terminal\n\n"
    fi

    read ans
    
    case $ans in 
    0 | 1 | 2 | 3 | 4)
        if [ ${gov[$ans]} = $curr_gov ]
        then
            tput bold
            printf "\nGovernor already set on $curr_gov...\n"
            tput sgr0
            loop=2
        else
            sudo cpupower frequency-set -g ${gov[$ans]}
            tput bold 
            printf "\nGovernor changed to ${gov[$ans]}!\n"
            tput sgr0
            sleep 3
            loop=0
        fi
        ;;
    p)
        loop=3
        ;;
    q)
        loop=0
        ;;
    *)
        tput bold
        printf "\nError: wrong answer!! Exiting"
        3dots
        tput sgr0
        loop=0
        ;;
    esac
done

exit 0