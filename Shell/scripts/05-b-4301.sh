#Напишете shell script, който автоматично да попълва файла указател от предната задача по подадени аргументи: име #на файла указател, пълно име на човека (това, което очакваме да е в /etc/passwd) и избран за него nickname.
#Файлът указател нека да е във формат:
#<nickname, който лесно да запомните> <username в os-server>
#// може да сложите и друг delimiter вместо интервал
#
#Примерно извикване:
#./pupulate_address_book myAddressBook "Ben Dover" uncleBen

#Добавя към myAddressBook entry-то:
#uncleBen <username на Ben Dover в os-server>

#***Бонус: Ако има няколко съвпадения за въведеното име (напр. има 10 човека Ivan Petrov в /etc/passwd), всички те #да се показват на потребителя, заедно с пореден номер >=1,
#след което той да може да въведе някой от номерата (или 0 ако не си хареса никого), и само избраният да бъде #добавен към указателя.

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

