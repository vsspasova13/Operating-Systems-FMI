#Използвайки файл population.csv, намерете през коя година в България има най-много население.

grep '^Bulgaria' population.csv | sort -k4 -nr -t "," | head -n1 | cut -d "," -f3
