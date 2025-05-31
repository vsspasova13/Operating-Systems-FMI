#!/bin/bash

if [[ ${#} -lt 2 ]]
    then echo "You shoud give number of seconds and command"
    exit 1
fi

seconds=$1
shift 1
cmd="$@"

count=0
dur=0

while true
do

startt=$(date +%s.%N)
eval "$cmd"
endd=$(date +%s.%N)
count=$(( count + 1 ))

period=$(echo "$endd - $startt" | bc )
dur=$(echo "$dur + $period" | bc)
res=$(echo "$dur > $seconds" | bc)

if [[ $res -eq 1 ]]
    then break
fi

done

avg=$(echo "scale=2; $dur / $count" | bc)

echo "Ran the command $cmd $count times for $(printf '%.2f' "$dur") seconds"
echo "Average runtime: $avg seconds"
