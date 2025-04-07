#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "You shoud give one file!"
fi

file=$1

if [[ ! -f $file ]]
    then echo "$file is not a file!"
fi

temp=$(mktemp)
cut -d' ' -f2 $file | sort | uniq -c |sort -nr | head -n3 > $temp

while read -r count siteName
do

httpCount=0
othersCount=0

    while IFS=" " read -r client host _ _ _ method identif protocol code _
    do

    if [[ $host == $siteName ]]
        then if [[ $protocol == "HTTP/2.0" ]]
                then httpCount=$(( httpCount + 1 ))
             else othersCount=$(( othersCount + 1 ))
             fi
    fi
    done < $file

echo "$siteName HTTP:$httpCount NON-HTTP:$othersCount"

awk -v site=$siteName -F' ' '$2==site && $9+0 > 302 {print $1}' $file | sort | uniq -c | sort -nr |head -n 5

done < $temp
