#Намерете колко физическа памет заемат осреднено всички процеси на потребителската група root. Вним#авайте, когато групата няма нито един процес.

ps -e -g root -o rss | awk 'BEGIN {sum = 0; count =0;} {sum += $1; count += 1;} END {if (count==0) {print count;} else {printf "%.2f\n", sum/count ;}}'

