#Да се напише shell скрипт, който чете от стандартния вход имената на 3 файла, обединява редовете на първите #два (man paste), подрежда ги по азбучен ред и резултата записва в третия файл.

#!/bin/bash

set -u
read -p "Enter three file names: " f1 f2 f3

if [[  ( ! ( -f ${f1} ) ) ||( ! ( -f ${f2} ) )  || ( ! ( -f ${f3})  ) ]]; then
    echo "This file does not exist!"
    exit 1

fi

cat f1 f2 | sort > f3

cat f3
