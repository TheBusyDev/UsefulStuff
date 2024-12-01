#!/bin/bash
#Execute this program (in background) using the following command line: '/home/[username]/Documents/loading.sh &'
#After executing this program, run 'pkill loading.sh' to stop it

n=0; m=50
while [ $n -le 60 ]
do
    tput sc

    printf "\nLoading"

    for l1 in $(seq 0 4 60); do if [ $n = $l1 ]; then printf "     /"; fi; done
    for l2 in $(seq 1 4 60); do if [ $n = $l2 ]; then printf ".    -"; fi; done
    for l3 in $(seq 2 4 60); do if [ $n = $l3 ]; then printf "..   \\"; fi; done
    for l4 in $(seq 3 4 60); do if [ $n = $l4 ]; then printf "...  |"; fi; done
    
    printf "\n["

    for g in $(seq $(( $n - 10 ))); do printf " "; done

    tput setab 21
    if [ $n -lt 10 ]
    then
        for h in $(seq $n); do printf " "; done
    
    elif [ $n -ge 10 ] && [ $n -le 50 ]
    then
        for i in $(seq 10); do printf " "; done
        
    else
        for j in $(seq $(( 60 - $n ))); do printf " "; done
    fi
    tput sgr0

    for k in $(seq $(( 50 - $n ))); do printf " "; done

    printf "]\n\n"

    n=$(( $n + 1 ))
    if [ $n = 60 ]; then n=0; fi
    sleep 0.075; tput rc; tput ed
done

exit 0
