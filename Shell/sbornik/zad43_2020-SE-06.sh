
#!/bin/bash

if [[ ${#} -ne 3 ]]
    then echo "The number of parameters should be 3"
    exit 1
fi

file=$1
key=$2
value=$3

date=$(date)
user=$(id -u)

temp=$(mktemp)

while IFS= read -r line
do

if [[ -z "$line" || "$line" =~ ^\s*# ]]; then
        echo "$line" >> "$temp"
        continue
fi

if echo "$line" | grep -q "^\s*$key\s*=\s*"
    then modified=$(echo "$line" | sed -E "s|$line|#$line #edited at $date by $user|")
         val=$(echo "$line" |sed -E "s/^\s*$key\s*=\s*(.*)$/\1/" | sed -E "s/\s*#.*//")
         if [[ "$val" != "$value" ]]
            then echo "$modified" >> "$temp"
                 echo "$key = $value #added at $date by $user" >> "$temp"
         else echo "$line" >> "$temp"
         fi
else echo "$line" >> $temp
fi

done < $file

mv "$temp" "$file"
