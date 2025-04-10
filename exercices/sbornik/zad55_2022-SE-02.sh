
#!/bin/bin

arguments=${@}

words=$(mktemp)
files=$(mktemp)

for arg in $arguments
do

if [[ "$arg" =~ ^-R ]]; then
    echo $arg | cut -c3-  >> $words
elif [[ -f $arg ]]; then
    echo $arg >> $files
fi

done

replaceWords()
{

tempFile=$1
myFile=$2

while IFS="=" read -r keyy value
do

sed -i "s/$keyy/$value/g" "$myFile"

done < "$tempFile"

}

editFile()
{

file=$1
pas=$(mktemp)

while IFS="=" read -r key val
do

    res=$(grep "\b$key\b" "$file")

    if [[ -z "$res" || "$res" =~ ^# ]]
        then continue
    else unique=$(pwgen 10 1)
         sed -i "s/$key/$unique/g" "$file"
         echo "$unique=$val" >> $pas
    fi

done < "$words"

replaceWords "$pas" "$file"

}

while IFS= read -r file
do
    echo "before: "
    cat "$file"
    editFile "$file"
    echo "after: "
    cat "$file"

done < $files
s0600353@astero:~$ vim zad72.sh
s0600353@astero:~$ cat scripts/zad55.sh
#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "number of arguments should be 2"
    exit 1
fi

dir=$1
num=$2

if [[ ! -d $dir ]]
    then echo "not falid dir"
    exit 1
fi

files=$(find "$dir" -type f -o -type l)
allFiles=$(mktemp)

toDelete=$(mktemp)

for file in $files
do

if [[ -L "$file" && ! -e "$file" ]]
    then rm "$file"
fi

name=$(basename $file .tar.xz)
echo "$name" >> $allFiles

done

unique=$(mktemp)
cat "$allFiles" | cut -d '-' -f1-2 | sort | uniq  >> $unique

forDir(){

fileName="${1}"
targetDir="${2}"
dirtemp=${3}

find "$targetDir" | grep "$fileName" | sort -t'-' -k3 -nr >> $dirtemp

}

deleteFiles(){

dirtemp=${1}
numm=${2}
percent=${3}

count=$(cat "$dirtemp" | wc -l)
if [[ $count -lt $numm ]]
    then
        while IFS= read -r fileee
        do
           rm $fileee

        done < $dirtemp
fi

while IFS= read -r file
do

usage=$(df $dir | tail -n1 | awk '{print $5}' | cut -d'%' -f1)
if [[ $usage -le $percent ]]
    then   return
fi

if [[ $count -eq $numm ]]
    then   return
fi

rm $file
count=$(( count - 1 ))

done < $dirtemp

}

while IFS= read -r name
do

i=1
i1=$(( i + 1 ))

    while [ $i -ne 4 ]
    do

    dirtemp=$(mktemp)

    forDir "$name" "$dir/$i" "$dirtemp"
    deleteFiles "$dirtemp" "$i1" "$num"

    i1=$(( i1 + 1 ))
    i=$(( i + 1 ))

    done

done < $unique
