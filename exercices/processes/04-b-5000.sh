#Намерете колко физическа памет заемат всички процеси на потребителската група root.
 
 ps -g root -o rss= | awk 'BEGIN {sum = 0} {sum += $1} END {print sum}'

