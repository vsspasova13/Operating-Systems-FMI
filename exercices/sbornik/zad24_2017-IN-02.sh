#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "You have to open it as root!"
#    exit 1
fi

if [[ ${#} -ne 1 ]]
    then echo "you have to write one name"
    exit 1
else
   name=$1
fi

moreProcesses(){

name=$1
count=0

while IFS= read -r user
do

if [[ $user == $name ]]
    then break
fi

count=$(( count + 1))
done < <(ps -e -o user --sort user | sort | uniq -c | sort -nr)

echo $count
}

averageTime()
{

count=0
sum=0

while IFS= read -r time
 do
 IFS=: read -r h m s <<< "$time"
 seconds=$(( h * 3600 + m * 60 + s ))
 sum=$(( sum + seconds ))
 count=$(( count + 1 ))

done < <(ps -e -o time | tail -n +2)

if [ $count -gt 0 ]
 then echo $(( sum / count ))
else
 echo 0
fi

}

killProcesses()
{
name=$1
avtime=$(averageTime)

while IFS= read -r user pid time
 do
 IFS=: read -r h m s <<< "$time"
 seconds=$(( h * 3600 + m * 60 + s))

 if [[ $seconds -gt $(( avtime * 2 )) ]]
    then echo "killing "$pid
    kill -TERM $pid
 fi

 done < <(ps -e -o user,pid,time | grep "$name")
}

processes_count=$(moreProcesses "$name")
echo "User $name has $processes_count processes than his."

avTime=$(averageTime)
echo "avgTime: $averageTime"

#killProcesses "$name"
