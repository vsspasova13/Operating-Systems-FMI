#Изведете всички обикновени файлове в директорията /tmp които са от вашата група, които имат write права за достъп за група или за останалите(o=w)

find /tmp -type f -group $(id -gn) \( -perm -g=w -o -perm -o=w \)

