#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "You should give 2 arguments!"
#    exit 1
fi

file=$1
stype=$2

if [[ ! -f $file || ! -s $file ]]
    then echo "invalid arguments"
#    exit 1
fi

temp=$(mktemp)

awk -F',' -v type="$stype" '$5 == type {print $0}' "$file" > $temp

topSz=$(awk -F',' '{print $4}' $temp| sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

resTemp=$(mktemp)

awk -F',' -v st="$topSz" '$4 == st {print $0}' "$temp" > $resTemp
res=$(sort -t',' -k7 -nr $resTemp | head -n1 | cut -d',' -f1)
echo "$res"

rm "$temp"
rm "$resTemp"
