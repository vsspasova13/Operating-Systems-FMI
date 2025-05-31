#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "Should be one parameter"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "$dir is not a valid directory"
    exit 1
fi

files=$(find $dir -type f)
count=$(cat "$files" | wc -l)

res=$(mktemp)

for file in $files
do

    temp=$(mktemp)
    tr ' .,' '\n  ' < "$file" >> "$temp"

    words=$(mktemp)
    sort "$temp" | uniq -c | sort -nr >> "$words"


    while IFS=" " read -r br word
        do

        if [[ -z $word ]]
            then continue
        fi

        if [[ $br -ge 3 ]]
            then echo "$word" >> "$res"
        fi

    done < "$words"

done

filesCount=$(mktemp)
sort "$res" | uniq -c | sort -nr >> "$filesCount"
newCount=$(( count / 2 ))

finalRes=$(mktemp)

while IFS=" " read -r broi duma
do

    if [[ $broi -ge $newCount ]]
        then echo "$duma" >> $finalRes
    fi

done < $filesCount

head -n3 $finalRes

rm "$temp" "$words" "$filesCount" "$res" "$finalRes"
