#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "You should give one directory name!"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "$dir is not a directory!"
    exit 1
fi

files=$(mktemp)

find $dir -type f -printf '%i %p \n' > $files

fout=$(mktemp)
while IFS= read -r line
do

name=$(echo $line | cut -d' ' -f2)
md=$(md5sum $name | cut -d' ' -f1)

echo "$md $line" >> $fout

done < $files


while read md5
do

temp=$(mktemp)
hasHardLinks=0
toDelete=$(mktemp)

    while read line
    do
        inod=$(echo $line | cut -d' ' -f2)
        fileName=$(echo $line | cut -d' ' -f3)
        if grep -q "$inod" $temp
            then $hasHardLinks=1
        else
            echo $fileName >> $toDelete
            echo $inod >> $temp
        fi
    done < <(cat $fout | grep "^$md5")


    if [[ $hasHardLinks -eq 1 ]]
        then tail -n +2 $toDelete > tp
        mv tp $toDelete
    fi

    while read file
    do

    echo $file

    done < $toDelete
    rm $temp $toDelete

done < <(cat $fout | cut -d " "  -f1 | sort | uniq )

rm $files $fout
