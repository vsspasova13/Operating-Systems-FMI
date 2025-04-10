#!/bin/bash

findSum()
{
  cmd=$1
  sum=0

  while IFS=" " read -r rs cd
  do

    if [[ "$cd" == "$cmd" ]]
        then sum=$(( sum + rs ))

    fi

  done

  echo "$sum"
}


while true
do

    pss=$(ps -e -o rss=,comm= --sort -rss,comm)

    cmds=$(ps -eo comm= | sort | uniq )

    temp=$(mktemp)

        while read -r cm
        do

            s=$(echo "$pss" | findSum $cm)

            if [[ "$s" -gt 65536 ]]
                then echo "$cm" >> "$temp"
            fi

        done <<< "$cmds"


    if [[ ! -s "$temp" ]]
        then  break
    else    echo "commands: "
            cat "$temp"

    fi

    echo "refreshing..."
    sleep 1

done
