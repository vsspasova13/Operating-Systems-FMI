#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "You should give 2 arguments!"
    exit 1
fi

file1=$1
file2=$2

if [[ ! -f $file1 || ! -f $file2 ]]
    then echo "The arguments should be valid csv files!"
    exit 1
fi

temp=$(mktemp)

getIndex()
{
line=$1
index=$(echo $line | cut -d',' -f1)
echo $index
}

getLineWithoutIndex()
{
line=$1
newLine=$(echo $line | cut -d',' --complement -f1)
echo $newLine
}

hasTheSameInFile()
{
file=$1
line=$2

if [[ ! -s $file ]]
    then echo ""
    return
fi

while IFS= read -r fline
do

fline2=$(getLineWithoutIndex $fline)
line2=$(getLineWithoutIndex $line)

if [[ $line2 == $fline2 ]]
    then echo $fline
         return
fi
done < $file

echo ""
}

while IFS= read -r line
do

outp=$(hasTheSameInFile $temp $line)

if [[ $outp == "" ]]
    then echo $line >> $temp
else
    ind=$(getIndex $line)
    findex=$(getIndex $outp)
           if [[ $ind -lt $findex ]]
              then sed -i "s|$outp|$line|g" "$temp"
           fi
fi

done < $file1

cat $temp > $file2
