
#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "You have to open it as root!"
    exit 1
fi

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

