#!/bin/bash

if [[ $# -ne 2 ]]
    then echo "There should be 2 arguments!"
#    exit 1
fi

dir=$1
file=$2

if [[ ! -d $dir ]]
    then echo "$dir is not a directory!"
#    exit 1
fi

#if [[ $(find . $dir) ]]
#    then echo "$dir should be empty!"
#    exit 1
#fi

temp=$(mktemp)
i=0

user=""

touch "$dir/dict.txt"

sorted=$(mktemp)
sort $file >> $sorted

while IFS= read -r line
do

if [[ ! $line =~ \(*\): ]]
    then curr=$(echo $line | cut -d':' -f1)
else curr=$(echo $line | cut -d'(' -f1 | cut -d' ' -f1,2)
fi

if [[ -z $user ]]
    then user=$curr
fi

if [[ $curr != $user ]]
    then echo "$user;$i" >> "$dir/dict.txt"
         i=$(( i + 1 ))
         user=$curr
fi
    echo $line >> "$dir/$i.txt"

done < $sorted

echo "$user;$i" >> "$dir/dict.txt"
