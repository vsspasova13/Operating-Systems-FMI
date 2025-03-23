#Да се напише shell скрипт, който приканва потребителя да въведе пълното име на директория и извежда на #стандартния изход подходящо съобщение за броя на всички файлове и всички директории в нея.

#!/bin/bash

read -p "Enter full directory name: " dir

if [[ ! -d ${dir} ]] ; then
    echo "no such directory"
    exit 1
fi

files=$(find "${dir}" -mindepth 1 -type f | wc -l)
directories=$(find "${dir}" -mindepth 1 -type d| wc -l)

echo "files:  ${files}"
echo "directories: ${directories}"
echo "total: $((files + directories))"

