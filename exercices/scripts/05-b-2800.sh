#Да се напише shell скрипт, който приема точно един параметър и проверява дали подаденият му параметър се #състои само от букви и цифри.

#!/bin/bash

read -p "Enter variable: " v
if echo "$v" |grep -Eq '^[a-zA-Z0-9]+$'; then
    echo "true"
else echo "false"
fi
