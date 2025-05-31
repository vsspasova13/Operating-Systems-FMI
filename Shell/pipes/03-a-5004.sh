#Изведете целите редове от /etc/passwd за хората от 03-a-5003

cat /etc/passwd | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f2 | grep -E -v '.{8,}$' | grep -E '[^a-zA-Z]' |sort |uniq | xargs -I {} grep -w {} /etc/passwd
