#!/bin/bash

if [[ ${#} -ne 3 ]]
    then echo "You need to write 3 param"
else
    src=$1
    dst=$2
    str=$3
fi

if [[ ! -d $src ]] || [[ ! -d $dst ]]
    then echo "SRC and DST need to be directories"
elif [[ ! -z $(ls -A $dst) ]]
    then echo "DST needs to be empty!"
fi

if [[ $(id -u) -ne 0 ]]
    then echo "You have to open it as a root!"
fi

for file in $(find $src -name "*$str*")
do

path=$(realpath $file)
newPath=$(sed -e "s/$src/$dst/" <<< $path)
newPath=$(awk -F'/' 'BEGIN {OFS="/"}{for(i=1;i<NF;i++){printf "%s%s", $i, OFS}}' <<< "$newPath")
mkdir -p $newPath $dst
mv -v $file $newPath

done
