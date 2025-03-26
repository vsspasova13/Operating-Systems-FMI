 #!/bin/bash

file=$1
name=$2
nickname=$3

count=$(grep "$name" ~/names.txt | wc -l)

if [ "$count" -eq 1 ]; then
   echo "$nickname -> $name" >> $file
   #exit 0

elif [ "$count" -eq 0 ]; then
    echo "Nqma takova brat"

else
   fn=( $(grep "$name" ~/names.txt | cut -d ':' -f1) )
   echo "-1 exit"

   for i in $(seq 0 $((count - 1))); do
        echo "$i  ${fn[$i]} $name"
   done
   read option

   if [[ "$option" -ge "$count" || "$option" -lt 0 ]]; then
        echo "invalid option"
        #exit 1
   else
        echo "$nickname -> $name , ${fn[$option]}" >> $file
   fi

fi

