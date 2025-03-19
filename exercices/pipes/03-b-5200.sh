#Намерете броя на символите, различни от буквата 'а' във файла /etc/passwd

grep -o . /etc/passwd | grep '[^a]' | wc -l

