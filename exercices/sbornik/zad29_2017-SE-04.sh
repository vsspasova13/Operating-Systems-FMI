
#!/bin/bash

if [[ ${#} -ne 1 ]] && [[ ${#} -ne 2 ]]; then
    echo "You need to write a leas tone directory!"
    exit 1
fi

dir=$1
file=$2

if [[ ! -d $dir ]]; then
    echo "$dir is not a directory!"
    exit 1
fi

broken=0

while IFS= read -r link
do

target=$(readlink $link)
if [[ -e $target ]]
    then broken=$(( broken  + 1 ))
elif [[ -n $file ]]
    then echo "$link -> $target" >> $file
else
    echo "$link -> $target"
fi

done < <(find $dir -type l)

if [[ -n $file ]]
    then echo "Broken symlinks: $broken" >> $file
else
    echo "Broken symlinks: $broken"
fi
