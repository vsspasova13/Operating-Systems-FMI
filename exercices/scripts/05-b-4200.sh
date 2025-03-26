#Имате компилируем (a.k.a няма синтактични грешки) source file на езика C. Напишете shell script, който да покaзва #колко е дълбоко най-дълбокото nest-ване (влагане).
#Примерен .c файл:
#
##include <stdio.h>
#
#int main(int argc, char *argv[]) {
#
#  if (argc == 1) {
#		printf("There is only 1 argument");
#	} else {
#		printf("There are more than 1 arguments");
#	}
#
#	return 0;
#}
#Тук влагането е 2, понеже имаме main блок, а вътре в него if блок.
#
#Примерно извикване на скрипта:
#
#./count_nesting sum_c_code.c
#
#Изход:
#The deepest nesting is 2 levels

#!/bin/bash

file=${1}

if [ ! -f "$file" ]; then
    echo "no such file!"
    exit 1
fi

max=0

max=$(grep -c '{[^}]*{' "$file" | wc -l )

max=$(( (max) + 1))

echo $max
