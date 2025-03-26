#!/bin/bash

file=${1}

if [ ! -f "$file" ]; then
    echo "no such file!"
    exit 1
fi

max=0

max=$(grep -c '{[^}]*{' "$file" | wc -l )

max=$(( (max) + 1))

echo $max
