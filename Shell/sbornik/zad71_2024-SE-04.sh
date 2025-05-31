#!/bin/bash

if [[ ${#} -ne 1 ]]
    then echo "you shoud give file name"
    exit 1
fi

file=$1

createFile(){

fileToCreate=$1
echo "Bake called for $fileToCreate"

line=$(grep "^$fileToCreate[[:space:]]*:" bakefile)

if [[ $(echo "$line" | wc -l ) -ne 1 ]]
    then echo "invalid"
    exit 1
fi

if [[ -z "$line" ]]
  then if [[ ! -f "$fileToCreate" ]]
        then echo "error"
        exit 1
       fi
else
    dependencies=$(echo "$line" | cut -d':' -f2)
    cmd=$(echo "$line" | cut -d':' -f3-)

    for d in $dependencies
    do
        if [[ ! -f "$d" ]]
            then createFile "$d"
        fi
    done

    needBuild=0

    if [[ ! -f $fileToCreate ]]
        then needBuild=1
    else
        for dp in $dependencies
        do

           if [[ $dp -nt $fileToCreate ]]
                then needBuild=1
           fi

        done
    fi

    if [[ $needBuild -eq 1 ]]
        then  echo "creating $fileToCreate: $cmd"
              eval "$cmd"
    fi
fi
}

createFile $file
