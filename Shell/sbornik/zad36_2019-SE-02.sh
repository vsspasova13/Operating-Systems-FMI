
#!/bin/bash

str=$1

if [[ $str == "-n" ]]
    then N=$2
    shift 2
else N=10
fi

input=("$@")

for file in "$@"
do

   tail -n $N $file | while IFS= read -r line
   do
    timee=$(echo $line | cut -d' ' -f1,2)
    data=$(echo $line | cut -d' ' --complement -f2)
    echo "$timee $file $data"

   done

done | sort
