--от предната задача: когато вече сте получили myetc с файлове, архивирайте
--всички от тях, които започват с 'c' в архив, който се казва c_start.tar
--изтрийте директорията myetc и цялото и съдържание
--изтрийте архива c_start.tar

find -type f -name 'c*' -exec tar -rvf c_start.tar {} \;
rm -r ~/myetc
rm c_start.tar



