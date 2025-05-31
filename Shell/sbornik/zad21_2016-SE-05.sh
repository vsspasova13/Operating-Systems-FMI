#!/bin/bash

if [[ ! ${#} -eq 2 ]]
   then  echo "You should give 2 file names!"
         exit 1

else file1=$1
     file2=$2
fi

if [[ ! -f $file1 || ! -f $file2 ]]
    then echo "Files do not exist!"
         exit 1
fi

if [[ $(grep "$file1" $file1 | wc -l) -gt $(grep "$file2" $file2 | wc -l) ]]
    then targetFile=$file1
         name=$(basename "$file1")
else targetFile=$file2
     name=$(basename "$file2")
fi

content=$(cut -d'-' -f2 $targetFile | sort -k1)

while IFS= read -r line
do

echo "$line" >> "$name.songs"

done <<< $content

