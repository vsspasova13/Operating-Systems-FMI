#Да се напише shell скрипт, който чете от стандартния вход име на файл и символен низ, проверява дали низа се #съдържа във файла и извежда на стандартния изход кода на завършване на командата с която сте проверили н#аличието на низа.
#NB! Символният низ може да съдържа интервал (' ') в себе си.

#!/bin/bash

set -u
echo -n  "Enter file name: "
read file
echo -n  "Enter string: "
read -r str

if [[ ! -f  "$file" ]] ; then
    echo "The file doesn not exist"
    exit 1

fi

grep -Eq "$str" "$file"

exit_code=$?

echo "The code is $exit_code"

