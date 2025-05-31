#!/bin/bash

min=$1
max=$2

mkdir a
mkdir b
mkdir c

while IFS= read -r file
do

lines=$(wc -l < $file)

if [[ $lines -lt $min ]]
    then mv $file a
elif [[ $lines -gt $min && $lines -lt $max ]]
    then mv $file b
else mv $file c

fi

done < <(find -type f)
