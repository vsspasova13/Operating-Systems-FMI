#!/bin/bash

dir=$1

if [[ ! -d "$dir" ]]
    then echo "Not directory"
    exit 1
fi

pwd_file="$dir/foo.pwd"
cfg_dir="$dir/cfg"

touch "foo.cfg"

find "$cfg_dir" -type f -name "*.cfg" | while IFS= read -r file
do

result=$("$dir/validate.sh" $file 2>/dev/null)
status=$?

name=$(basename $file .cfg)

if [[ $status -eq 0 ]]
    then cat $file >> "foo.conf"
         if ! grep -q "^$name:" "$pwd_file"
            then  passwd=$(pwgen 10 1)
            hash=$(mkpasswd "$passwd")
            echo "$name:$passwd"
            echo "$name:$hash" >> "$pwd_file"
         fi

elif [[ $status -eq 1 ]]
    then
    while IFS= read -r line
    do
        echo "$(basename "$file"): $line" >&2

    done <<< "$result"
fi

done
