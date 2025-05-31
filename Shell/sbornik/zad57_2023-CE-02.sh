#!/bin/bash

if [[ ${#} -ne 3 ]]
    then echo "You should give 3 arguments!"
    exit 1
fi

file1=$1
file2=$2
black_hole=$3

if [[ ! -f "$file1" || ! -f "$file2" || ! -s "$file1" || ! -s "$file2" ]]
    then echo "Invalid arguments"
    exit 1
fi

dist1=$(grep "$black_hole" $file1 | cut -d':' -f2 | awk '{print $1}')
dist2=$(grep "$black_hole" $file2 | cut -d':' -f2 | awk '{print $1}')

if [[ -z $dist1 && -z $dist2 ]]
    then echo "Error! Black hole not found!"
elif [[ -z $dist1 ]]
    then echo $file2
elif [[ -z $dist2 ]]
    then echo $file1
fi

if [[ $dist1 -lt $dist2 ]]
    then echo $file1
else echo $file2
fi
