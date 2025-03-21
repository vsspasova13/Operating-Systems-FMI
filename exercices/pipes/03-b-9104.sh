#Да се изведат всички албуми, сортирани по година. 

find -mindepth 1 | cut -d "-" -f2 | cut -d "(" -f2 | cut -d ")" -f1 | sort -k2 -t "," -n | uniq | cut -d "," -f1

