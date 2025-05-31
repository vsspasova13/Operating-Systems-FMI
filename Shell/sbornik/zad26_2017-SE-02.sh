#!/bin/bash

if [[ ${#} -eq 0 ]]
    then echo "there shoud be at least directory name!"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "no such directory!"
    exit 1
fi

numberHardLinks()
{

dir=$1
num=$2

echo "Files with n number of hardLinks: "
find $dir -type f -exec stat -c '%h %n' {} + 2>/dev/null | while read -r count name
    do
        if [[ $count -gt $num ]]
            then echo "$name, links: $count"
        fi
done

}

findBrokenSymlinks()
{

dir=$1

echo "Broken symlinks: "

while IFS= read -r link
do

    if [[ ! -e $link ]]
        then echo $link
    fi

done < <(find $dir -type l 2>/dev/null)

}

if [[ $# -eq 2 ]]
    then
       num=$2
       numberHardLinks $dir $num
else
    findBrokenSymlinks $dir
fi
