#Създайте файл, който да съдържа само последните 10 реда от изхода на 02-a-5403

find /etc -maxdepth 1 -type d | tail -n 10 > output_file.txt

