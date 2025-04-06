#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "There should be 2 arguments"
    exit 1
fi

dir=$1
str=$2

temp=$(mktemp)
sorted=$(mktemp)

while IFS= read -r line
do

x=$(echo $line | cut -d'-' -f2 | cut -d'.' -f1)
z=$(echo $line | cut -d'.' -f4 | cut -d'-' -f1)
y=$(echo $line | cut -d'.' -f3 | cut -d'-' -f1)

echo "$line" >> $temp
echo "$x.$y.$z" >> $sorted

done < <(find $dir -maxdepth 1 -type f -printf '%f\n' | grep -E "vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-${str}")

target=$(sort -k1,1 -k2,2 -k3,3 -nr -t'.' $sorted | head -n1)
result=$(grep  "${target}" $temp)
echo $result
