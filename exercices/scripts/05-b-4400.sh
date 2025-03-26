#!/bin/bash

count=${#}

if [[ count -eq 1 ]] ; then
    dir1=$1
    dir2=$(date +'%Y-%m-%d')
    mkdir $dir2
else
    dir1=$1
    dir2=$2
fi

if [[ ! -d $dir1 || ! -d $dir2 ]]; then
    echo "opa greshka"
fi

find "$dir1" -type f -mmin -45  -exec cp {} "$dir2" 2>/dev/null \;

