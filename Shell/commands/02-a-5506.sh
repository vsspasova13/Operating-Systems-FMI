#Изтрийте файловете в home директорията си по-нови от practice/01/f3 (подайте на rm опция -i за да може да изберете само тези които искате да изтриете).

find -type f -newer practice/01/f3 -exec rm -i {} +

