#За всяка група от /etc/group изпишете "Hello, <група>", като ако това е вашата група, напишете "Hello, <група> - I am here!".

cat /etc/group | sort | uniq | cut -d ":" -f1 | awk -v "mygr=$(id -Gn)" ' $1 == mygr {printf "Hello " mygr " I am here\n"} $1 != mygr {printf "Hello " $1 "\n"}'
