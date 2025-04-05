
#!/bin/bash

while read -r line
do
  user=$(echo $line | cut -d':' -f1)
  home=$(echo $line | cut -d':' -f6)

  if [[ ! $home =~ ^/home/ ]]
  then
    echo $line
  else
    rights=$(ls -ld $home | cut -d' ' -f1 | cut -c 3)
    if [[ $rights != "w" ]]
       then  echo $line
    fi
  fi

done < /etc/passwd

