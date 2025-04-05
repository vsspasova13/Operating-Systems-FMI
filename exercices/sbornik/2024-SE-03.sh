#ChordPro е текстов формат за представяне на текстове на песни, анотирани с акорди. 
#Примерен откъс: For [Fmaj7]here am I [Em]sitting in a tin can 
#[Fmaj7]Far above the [Em]world 
#[Bb]Planet Earth is [Am]blue and there's [G]nothing I can [F]do 
#Всяка поредица от символи, оградена в квадратни скоби, ще наричаме акорд. 
#Първите един или два символа на акорда наричаме основен тон. Напишете скрипт transpose.sh , 
#който приема един аргумент (неотрицателно число 𝑁). Скриптът трябва да чете текст във формàта ChordPro от stdin и да 
#изписва аналогичен текст на stdout , 
#заменяйки единствено основните тонове по следната схема: A Bb B C Db D Eb E F Gb G 
#Числото 𝑁 задава брой преходи по ребрата за замяна. Например, при изпълнение на скрипта с 𝑁 = 3 
#върху горния пример, резултатът би бил: 
#For [Abmaj7]here am I [Gm]sitting in a tin can 
#[Abmaj7]Far above the [Gm]world 
#[Db]Planet Earth is [Cm]blue and there's [Bb]nothing I can [Ab]do


#!/bin/bash
  array=("A" "Bb" "B" "C" "Dd" "D" "Eb" "E" "F" "Gg" "G" "Ab")

   n=${1}

  #read -r line
  line="For [Fmaj7]here am I [Em]sitting in a tin can"

  words=$(echo "$line" | grep -Eo '\[[^]]+\]')

  echo "$words"

  replace(){

  word="$1"

  for i in ${!array[@]}
  do

  if  echo "$word" | grep -q "\[${array[$i]}" ; then
    index=$(( ($i + n) % 12 ))
    word=$(echo "$word" | sed "s/\[${array[$i]}/\[${array[$index]}/g")
   echo "$word"
   return
    fi

  done
  echo "$word"
  }

  for i in $words
  do

  new=$(replace "$i")

  old=$(echo $i | sed  's/\[/\\[/g; s/\]/\\]/g' )
  neww=$(echo $new | sed  's/\[/\\[/g; s/\]/\\]/g')
  line=$(echo "$line" | sed  "s/$old/$neww/g")


  done

  echo "$line"
