#!/bin/bash

echo "Please enter input (press CTRL+D to stop)"
input=$(cat)

maxSum=0
minNum=0
hadBeenSet=0

getAbss()
{

num=$1
abss=$(( -num ))
echo $abss

}

getDigitsSum()
{

num=$1
if [[ $num -lt 0 ]]
    then num=$(getAbss $num)
fi

sum=0

while [ $num -gt 0 ]
do

digit=$(( num % 10 ))
sum=$(( sum + digit ))
num=$(( num / 10 ))

done

echo $sum
}


while IFS= read -r line
do

if [[ ! $line =~ ^-?[0-9]+$ ]]
    then continue
fi

sum=$(getDigitsSum $line)

if [[ $hadBeenSet -eq 0 ]]
    then hadBeenSet=1
         minNum=$line
         maxSum=$sum
elif [[ $sum -gt $maxSum ]]
    then maxSum=$sum
         minNum=$line
elif [[ $sum -eq $maxSum ]]
    then  if [[ $line -lt $minNum ]]
            then minNum=$line
          fi
fi

done <<< $input

echo "min num: $minNum"
