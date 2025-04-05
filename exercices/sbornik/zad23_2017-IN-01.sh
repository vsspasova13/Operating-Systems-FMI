#!/bin/bash

fileName=$1
str1=$2
str2=$3

if [[ ${#} -ne 3 ]]
    then echo "there shoud be exactly 3 arguments"
fi

if [[ ! -f $fileName ]]
    then echo "file does not exist"
    exit 1
fi

line1=$(grep "$str1=" $fileName)
line2=$(grep "$str2=" $fileName)

value1=$(echo $line1 | cut -d'=' -f2 )
value2=$(echo $line2 | cut -d'=' -f2 )

tempFile=$(mktemp)

for symbol in $value2
do

if [[ -z $(echo $value1 | grep "$symbol") ]]
then  echo -n "$symbol " >> $tempFile
fi

done

newKey=$(head -n 1 "$tempFile")

sed -i "s/$line2/$str2=$newKey/g" $fileName
