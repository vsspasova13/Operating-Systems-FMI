#!/bin/bash

file=$1

if [[ -z "$file" ]]; then
  echo "No file given!"
  exit 1
fi

# Проверка дали файлът съществува
if [[ ! -f "$file" ]]; then
  echo "This file doesn't exist!"
  exit 1
fi

cat $file  | cut -d'-' -f2 |awk 'BEGIN {i=1} {print i". "$0; i++}' | sort -k2

