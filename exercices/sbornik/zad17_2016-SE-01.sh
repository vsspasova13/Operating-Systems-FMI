#!/bin/bash

if [[ ${#} -eq 0 ]]
   then  echo "Not enough parametres."
else dir=${1}
fi

if [[ -d $dir ]]
  then echo "Broken links: "

  while IFS= read -r link; do
    target=$(readlink -e $link)
    if [[ -z $target ]]; then
        echo $link
    fi
  done < <(find $dir -type l )

else
   echo "The parameter isn't a directory."
fi

