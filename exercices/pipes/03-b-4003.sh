#Изведете статистика за най-често срещаните символи в трите файла.

cat file1 file2 file3 | sed 's/./&\n/g' | sort | uniq -c | sort -nr
