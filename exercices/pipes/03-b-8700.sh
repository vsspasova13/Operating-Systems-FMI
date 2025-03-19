#1. Изведете GID-овете на 5-те най-големи групи спрямо броя потребители, за които
#съответната група е основна (primary).

cut /etc/passwd -d ":" -f4 | sort -n | uniq -c| sort -nr | head -n 5

#2. (*) Изведете имената на съответните групи.

cut /etc/passwd -d ":" -f4 | sort -n | uniq -c | sort -nr | head -n5 |awk '{print $2}' |  xargs -I{} grep ':{}:'  /etc/group | cut -d ':' -f1

         