#Копирайте <РЕПО>/exercises/data/emp.data във вашата home директория.
#Посредством awk, използвайки копирания файл за входнни данни, изведете:

#- общия брой редове
awk 'END {print NR}' emp.data

#- третия ред
cat emp.data | awk ' NR == 3 {print $0}'

#- последното поле от всеки ред
cat emp.data | awk ' {print $NF}'

#- последното поле на последния ред
 cat emp.data | awk 'END {print $NF}'

#- всеки ред, който има повече от 4 полета
awk 'NF>4 {print $0}' emp.data

#- всеки ред, чието последно поле е по-голямо от 4
 awk '$NF > 4 {print $0}' emp.data

#- общия брой полета във всички редове
 cat emp.data |  awk 'BEGIN {i = 0} {i += NF} END {print i}'

#- броя редове, в които се среща низът Beth
 awk -v name='Beth' \ 'BEGIN {i = 0} $1 == name {i += 1} END {print i}' emp.data
 awk '/Beth/ {print}' emp.data | awk 'END {print NR}'

#- най-голямото трето поле и редът, който го съдържа
awk 'BEGIN {max = 0; line = " "} {if ($3 > max) {max = $3; line = $0}} END {printf line " "max"\n"}' emp.data

#- всеки ред, който има поне едно поле
 awk 'NF > 2' emp.data

#- всеки ред, който има повече от 17 знака
 awk '(length $0) > 17' emp.data

#- броя на полетата във всеки ред и самият ред
awk '{printf NF " "$0 "\n" }' emp.data

#- първите две полета от всеки ред, с разменени места
awk '{printf $2 " " $1 "\n"}' emp.data

#- всеки ред така, че първите две полета да са с разменени места
awk ' {{temp = $1; $1 = $2; $2 = temp;} print}' emp.data

#- всеки ред така, че на мястото на първото поле да има номер на реда
awk '{{$1 = NR} print}' emp.data

#- всеки ред без второто поле
awk '{{$2 = "\t"} print}' emp.data

#- за всеки ред, сумата от второ и трето поле
awk '{{sum = $2 + $3} printf sum "\n"}' emp.data

#- сумата на второ и трето поле от всеки ред
awk 'BEGIN {sum = 0} {sum += $2 + $3} END {print sum}' emp.data