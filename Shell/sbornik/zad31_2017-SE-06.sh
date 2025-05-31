#!/bin/bash

if [[ $(id -u) -ne 0 ]]
    then echo "You shoud enter it as a root"
    exit 1
fi

isHomeDir()
{
home=$1

if [[ -d $home && $home =~ ^/home/ ]]
    then echo 1
else echo 0
fi
}

isOwner()
{
user=$1
home=$2

owner=$(ls -ld $home | awk '{print $3}' )

if [[ $user == $owner ]]
    then echo 1
else echo 0
fi
}

haveRightsToWrite()
{
home=$1

rights=$(ls -ld $home | awk {'print $1'} | cut -c3)

if [[ $rights == "w" ]]
    then echo 1
else echo 0
fi
}

rootRss()
{
sum=$(userRss "root")
echo $sum
}

userRss()
{
user=$1
sum=0

while IFS= read -r user rss
do

sum=$(( sum + rss ))

done < <(ps -e -o user,rss | grep "^$user ")

echo $sum
}

temp=$(mktemp)

while IFS= read -r line
do

user=$(echo $line | cut -d':' -f1)
home=$(echo $line | cut -d':' -f6)
uid=$(echo $line | cut -d':' -f3)

if [[ $uid -eq 0 ]]; then
        continue
    fi

if [[ $(isHomeDir $home) -eq 0 ]]
    then echo $line >> $temp
elif [[ $(isOwner $user $home) -eq 0 ]]
    then echo $line >> $temp
elif [[ $(haveRightsToWrite $home) -eq 0 ]]
    then echo $line >> $temp
fi

done < /etc/passwd

cat $temp

while IFS= read -r line
do

user=$(echo $line | cut -d':' -f1)
if [[ $(userRss $user) -gt $(rootRss) ]]
    then pkill -u $user
         echo "killing $user's processes"
fi

done < $temp
