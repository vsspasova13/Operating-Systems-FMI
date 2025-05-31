#!/bin/bash

input=$@

for file in $input
do

serial=$(cat "$file" | grep -e ".*SOA*." | cut -d' ' -f7)

if [[ -z "$serial" || $(echo "$serial" | wc -l ) -gt 1 ]]
    then echo "Error"
    exit 1
fi

if echo "$serial" | grep -q  "("
    then serial=$(cat "$file" | grep -A 1 "SOA" | tail -n1 |cut -d';' -f1 | xargs)

fi

year=$(echo "$serial" | cut -b 1-4)
month=$(echo "$serial" | cut -b 5-6)
day=$(echo "$serial" | cut -b 7-8)

if [[ "$year" == "$(date '+%Y')" && "$month" == "$(date '+%m')" && "$day" == "$(date '+%d')" ]]
    then      lastDigits=$(echo $serial | cut -b9-10)
              lastDigits=$((10#$lastDigits + 1))
              if [[ $lastDigits -eq 100 ]]
                then echo "Error! Cannot modify!"
                exit 1
              else otherDigits=$(echo $serial | cut -b1-8)
                   newSerial="${otherDigits}$(printf "%02d" "$lastDigits")"
                   sed -i "s/$serial/$newSerial/g" "$file"
              fi
else
    today=$(date '+%Y%m%d')
    today="$today"
    today+="00"
    sed -i "s/$serial/$today/g" "$file"
fi

done
