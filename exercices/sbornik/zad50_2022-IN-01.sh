#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "The number of arguments should be 2"
    exit 1
fi

src=$1
dest=$2

if [[ ! -d $src || ! -d $dest || ! -z $(ls -A $dest) ]]
    then echo "Invalid arguments"
#    exit 1
fi

files=$(find "$src" -type f -printf '%P\n' )

while IFS= read -r file
do

basename=$(basename $file)

if [[ $basename =~ ^\..+\.swp$ ]]; then
     name=$(basename "$basename" .swp | cut -b 2-)
     echo $name
     target=$(echo "$files" | grep -e "$name$")
     if [[ ! -z "$target" ]]; then continue
     fi
fi

mkdir -p "$dest"/"$(dirname "$file")"
cp "$src"/"$file" "$dest"/"$(dirname "$file")"

done < <(echo "$files")
