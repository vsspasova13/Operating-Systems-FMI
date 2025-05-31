#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "The number of arguments should be 2!"
    exit 1
fi

src=$1
dst=$2

if [[ ! -d $src ]]
    then echo "$src shoud be valid directory!"
    exit 1
fi

mkdir -p "$dst/images"

i=0

find $src -type f -name "*.jpg" |while IFS= read -r file
do

album=""
newLine=$file

brackets=$(echo $file | grep -Eo '\([^)]*\)' )

if [[ -n $brackets ]]
    then
        for br in $brackets
        do
        newLine=$(echo $newLine | sed  "s/$br//g")
        done
else
    album="misc"
fi

newLine=$(echo $newLine | sed -e 's/  */ /g' -e 's/ \././g')
title=$(echo $newLine | sed 's/\.jpg//g' | cut -d'/' -f2)

if [[ -z $album ]]
    then
    album=$(tail -n1 <<< "$brackets" | sed -e 's/[()]//g')
fi

datee=$(stat --format='%Y' "$file")
formated_date=$(date -d @$datee '+%Y-%m-%d')

sum=$(sha256sum "$file" | head -c16)
#echo $sum

cp "$file" "$dst/images/$sum$i.jpg"

mkdir -p "$dst/by-date/$formated_date/by-album/$album/by-title"
mkdir -p "$dst/by-date/$formated_date/by-title"
mkdir -p "$dst/by-album/$album/by-date/$formated_date/by-title"
mkdir -p "$dst/by-album/$album/by-title"
mkdir -p "$dst/by-title"



ln -s "$dst/images/$sum$i" "$dst/by-date/$formated_date/by-album/$album/by-title/$title.jpg"
ln -s "$dst/images/$sum$i" "$dst/by-date/$formated_date/by-title/$title.jpg"
ln -s "$dst/images/$sum$i" "$dst/by-album/$album/by-date/$formated_date/by-title/$title.jpg"
ln -s "$dst/images/$sum$i" "$dst/by-album/$album/by-title/$title.jpg"
ln -s "$dst/images/$sum$i" "$dst/by-title/$title.jpg"

i=$(( i + 1 ))

done # | 2>/dev/null
