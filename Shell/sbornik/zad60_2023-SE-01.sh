#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "The number of arguments should be 2!"
    exit 1
fi

file=$1
dir=$2

if [[ ! -f $file || ! -d $dir ]]
    then echo "invalid arguments!"
    exit 1
fi

files=$(find "$dir" -type f -name "*.txt")

editFile()
{

fileEdit=$1

while IFS= read -r word
do

length=${#word}

found=$(grep -P "\b$word\b" "$fileEdit")

if [[ -n $found ]]
    then    newWord=$(printf '%*s' $length | tr ' ' '*')
            sed -i "s/\<$word\>/$newWord/g" $fileEdit
fi

done < "$file"

}

for file1 in $files
do

editFile "$file1"

done

