#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "You shoud give one config file"
    exit 1
fi

file=$1

if [[ -s $file  || ! -f $file]]
    then echo "invalid file"
    exit 1
fi

orig="/proc/acpi/wakeup"

while IFS= read -r line
do

if [[ "$line" =~ ^# || -z "$line" ]]
    then continue
fi

device=$(echo "$line" | awk '{print $1}')
option=$(echo "$line" | awk '{print $2}')

res=$(grep "^$device" "$orig")

if [[ -z $res ]]
    then echo "The device $device is not part of the config!"
    continue
fi

currOption=$(echo "$res" | awk '{print $3}')

if [[ "$currOption" != "$option" ]]
    then "$device" > "$orig"
    echo "Changed $device to $option"
fi

done < $file
