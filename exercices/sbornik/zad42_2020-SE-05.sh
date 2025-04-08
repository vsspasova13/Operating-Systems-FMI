#!/bin/bash

if [[ ${#} -ne 3 ]]
    then echo "Number of srguments should be 3"
    exit 1
fi

file1=$1
file2=$2
dir=$3

if [[ ! -f $file1 || ! -d $dir ]]
    then echo "Not valid arguments!"
    exit 1
fi

checkFile()
{

file=$1
i=0
isvalid=true


while IFS= read -r line
do

if [[ $line =~ ^# ]]
        then i=$(( i + 1 ))
        continue
elif [[ $line == "{ no-production };" ]] ||
     [[ $line == "{ volatile };" ]] ||
     [[ $line == "{ run-all; };" ]] ||
     [[ -z $line ]]
        then i=$(( i + 1 ))
        continue
else echo "Line $i:$line"
     i=$(( i + 1 ))
     isvalid=false
fi

done < $file

}

valid=$(mktemp)

find $dir -type f -name "*.cfg" | while IFS= read -r file
do

outp=$(checkFile $file)

if [[ -z $outp ]]
    then cat "$file" >> "$file2"
         printf "%s\n" "$file" >> "$valid"
#         echo "valid: $file"
else    echo "Error in $file:"
        echo "$outp"
fi

done


while IFS= read -r file
do

name=$(basename $file .cfg)

if ! grep -q "$name" $file1
    then passwd=$(pwgen 16 1)
         echo "$name:$passwd" >> $file1
         echo "$name $passwd"
fi

done < $valid
 0