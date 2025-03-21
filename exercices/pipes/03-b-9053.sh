#Използвайки файл population.csv, намерете коя държава има най-много население през 2016. А коя #е с най-малко население?
#(Hint: Погледнете имената на държавите)

sort -k4 -nr -t "," population.csv| cut -d "," -f1,3 | grep '2016$' | head -n1 | cut -d "," -f1
sort -k4 -n -t "," population.csv| cut -d "," -f1,3 | grep '2016$' | head -n1 | cut -d "," -f1
