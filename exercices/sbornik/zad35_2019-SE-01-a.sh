
#!/bin/bash

max=0

echo "Please input text(press CTRL+D to stop)"
input=$(cat)

getAbs()
{
num=$1

if [[ $num -lt 0 ]]
    then abss=$(( -num ))
else     abss=$num
fi

echo $abss
}

echo "output: "

while IFS= read -r line
do

flag=0

if [[ ! $line =~ ^-?[0-9]+$ ]]
    then continue
elif [[ $line -gt $max ]]
    then max=$line
elif [[ $(getAbs $line) -eq $max ]]
    then echo $line
fi

done <<< $input
