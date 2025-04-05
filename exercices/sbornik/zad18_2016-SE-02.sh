
#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "You have to open it as root!"
    exit 1
fi


num=$1

sum=0
user=$(ps -e -o uid --sort uid | tail -n +2 | head -n 1)
max=0
pidMax=0

while IFS=" " read -r uid pid rss
do

if [[ $user -ne $uid ]]
    then if [[ $sum -gt $num ]]
            then echo "user: "$user" more than "$num
           if [[ $rss -gt $max ]]
            then max=$rss
                 maxPid=$pid
           fi
            kill -TERM $pidMax
         fi
    sum=0
    user=$uid
    maxPid=0
    max=0
else sum=$(( rss + sum ))
fi

done < <(ps -e -o uid,pid,rss --sort uid | tail -n +2)
