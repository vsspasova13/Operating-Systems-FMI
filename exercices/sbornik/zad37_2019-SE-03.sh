#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "You shoud give directory"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "$dir is not valid directory!"
    exit 1
fi

find $dir -name "*_*.tgz" | while IFS= read -r file
do

last_modif=$(stat --format=%Y $file)

sum=$(sha256sum $file | cut -d' ' -f1)
if grep -q $sum "$dir/hashes.txt"
    then last_recorded_time=$(grep $sum "$dir/hashes.txt" | cut -d' ' -f2)
         if [[ $last_modif -gt $last_recorded_time ]]
            then echo "$sum $last_modif" >> "$dir/hashes.txt"
         else
            continue
         fi
else
    echo "$sum $last_modif" >> "$dir/hashes.txt"
fi

name=$(echo $file | cut -d'_' -f1)
date=$(echo $file | cut -d'-' -f2 | cut -d'.' -f1)

meow=$(tar -tf $file | grep -q "meow.txt" $$ echo "found")

if [[ -z $meow ]]
    then continue
elif [ ! -d "$dir/extracted" ]; then
    mkdir "$dir/extracted"
else
    mv $file "$dir/exctracted/$name\_$date.txt"
fi

done
