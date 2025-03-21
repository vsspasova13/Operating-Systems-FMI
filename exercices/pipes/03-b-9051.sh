Използвайки файл population.csv, намерете колко е общото население на света
през 2008 година. А през 2016?

cut population.csv -d "," -f3,4 | grep '^2016' |  cut -d "," -f2 |awk 'BEGIN {sum = 0} {sum += $1} END {printf sum "\n"}'

cut population.csv -d "," -f3,4 | grep '^2008' |  cut -d "," -f2 |awk 'BEGIN {sum = 0} {sum += $1} END {printf sum "\n"}'
