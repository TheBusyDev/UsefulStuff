#!/bin/bash

tput civis; tput bold; tput setab 76; tput setaf 232
echo "                                  "
echo "       CPU FREQUENCY STATUS       "
echo "                                  "
tput sgr0; tput bold

len=50  # bar length
refresh=3 # time to refresh

printf "\nCPU running at"; tput sc; 3dots &

while true
do
    total_freq=0

    for ((i=0; i<12; i++))
    do
        total_freq=$(( $total_freq + $(cat /sys/devices/system/cpu/cpufreq/policy$i/scaling_cur_freq) ))
    done

    curr_freq=$( echo "scale=6; $total_freq/(12*1000000)" | bc )
    cpu_perc=$( echo "scale=2; $curr_freq*100/3" | bc )
    level=$( echo "scale=0; $cpu_perc*$len/100" | bc )

    sleep $refresh; tput rc; tput ed 

    printf " $curr_freq GHz (usage: $cpu_perc %%)\n["

    for ((i=0; i<$level; i++))
    do 
        if [ $i -lt $(( $len/2 )) ]
        then
            tput setaf 226
        elif [ $i -lt $(( $len*3/4 )) ]
        then
            tput setaf 208
        else
            tput setaf 160
        fi

        printf "|"
    done

    tput sgr0 

    for ((; i<$len; i++))
    do
        printf " "
    done

    tput bold
    printf "]"
done

exit 0