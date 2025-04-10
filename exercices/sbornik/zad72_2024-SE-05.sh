#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "You should give 2 arguments"
    exit 1
fi

cmd=$1
file=$2

num=$($cmd)
if [[ $? -ne 0 ]]
    then exit 3
fi

datenow=$(date '+%Y-%m-%d %H')
dayOfWeek=$(date '+%A')
hourNow=$(date '+%H')

sum=0
count=0

echo "$num $(date '+%Y-%m-%d %H')" >> "$file"

while IFS=" " read -r value dateFile
do

dayOfWeekFile=$(date -d $dateFile '+%A')
hourOfDay=$(date -d $dateFile '+%H')

if [[ "$dayOfWeekFile" == "$dayOfWeek" && "$hourNow" == "$hourOfDay" ]]
    then sum=$(echo "scale=4; $sum + $value" | bc)
         count=$(( count + 1 ))
fi

done < "$file"

if [[ $count -eq 0 ]]
    then exit 0
fi

avg=$(echo "scale=4; $sum / $count" | bc)
lower=$( echo "scale=4; $avg / 2" | bc)
upper=$( echo "scale=4; $avg *2" | bc)

result1=$(echo "$num <= $upper" | bc)
result2=$(echo "$num >= $lower" | bc)

if [[ $result1 -ne 1 || $result2 -ne 1 ]]
    then echo "$datenow: $num abnormal"
    exit 2
fi
