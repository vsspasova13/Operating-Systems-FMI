#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "You shoud give one LOGDIR"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "$dir is not valid directory!"
    exit 1
fi

if [[ ! $(find $dir -mindepth 1 -maxdepth 1 -type d) ]]
    then echo "There is no protocol dir in dir $dir!"
    exit 1
fi

for protocol in $dir/*/
do
    if [[ ! $(find $protocol -mindepth 1 -maxdepth 1 -type d) ]]
        then echo "There is no account dir in protocol $protocol!"
#        exit 1
    fi

    for account in $protocol/*/
    do
        if [[ ! $(find $account -mindepth 1 -maxdepth 1 -type d) ]]
            then echo "There are no friends dir in account $account!"
#            exit 1
        fi

            for friend in $account/*/
            do
                if [[ ! $(find $friend -type f -name "*.txt") ]]
                    then echo "No friend files in account $account!"
#                    exit 1
                fi
            done
        done
    done

temp=$(mktemp)

find $dir -mindepth 4 | sort -t'/' -k4 >> $temp

u=""
lines=0

results=$(mktemp)

while IFS= read -r file
do

user=$(echo $file | cut -d'/' -f4)
line=$(wc -l < $file)

if [[ -z $u ]]
    then u=$user
fi

if [[ "$user" != "$u" ]]
    then echo "$u $lines" >> $results
    u=$user
    lines=$line
else
    lines=$(( lines + $line ))
fi

done < $temp

echo "$u $lines" >> $results

sort -k2 -nr $results | head -n10
