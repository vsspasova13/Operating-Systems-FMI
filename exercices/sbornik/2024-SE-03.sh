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
