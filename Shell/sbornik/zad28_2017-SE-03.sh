#!/bin/bash

if [ "$(id -u)" -ne 0 ]
    then echo "You need to run it as root!"
    exit 1
fi

user=-1
sum=0
count=0
maxRss=0
maxPid=0
avg=1

while IFS=" " read -r uid pid rss
do

if [[ $user -eq -1 ]]; then
    user=$uid
fi

if [[ $user -ne $uid ]]; then
    echo "u:$user c:$count s:$sum"
    user=$uid
    avg=$(( sum / count ))
    count=1
    sum=$rss
    if [[ $maxRss -gt $avg ]]
        then echo "killing process: $maxPid"
  #           kill -TERM $maxPid
    fi
    maxRss=$rss
    maxPid=$pid

else
    sum=$(( sum + rss ))
    count=$(( count + 1 ))
    if [[ $maxRss -lt $rss ]]; then
        maxRss=$rss
        maxPid=$pid
    fi
fi

done < <(ps -e -o uid,pid,rss --sort uid | tail -n +2)

echo "u:$user c:$count s:$sum"
