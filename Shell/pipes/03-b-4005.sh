 #Прочетете текстов файл file1 и направете всички главни букви малки като
запишете резултата във file2.

sed 's/[A-Z]/\L&/g' file2 > file1
