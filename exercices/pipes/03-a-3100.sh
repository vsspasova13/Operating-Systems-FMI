#Запазете само потребителските имена от /etc/passwd във файл users във вашата home директория.

cut /etc/passwd -d ':' -f 1 > ./users
