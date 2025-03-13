#Изведете имената на хората с второ име по-късо от 8 (<=7) символа според /etc/passwd 

cat /etc/passwd | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f2 | grep -E -v '.{8,}$' | grep -E -v [^а-яА-Я]
cat /etc/passwd | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f2 | grep -E -v '.{8,}$' | grep -E [^a-zA-Z]

