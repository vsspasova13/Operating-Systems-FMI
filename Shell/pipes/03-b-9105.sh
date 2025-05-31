# Да се преброят/изведат само песните на Beatles и Pink.

 find -mindepth 1| cut -c 3- | grep -E 'Beatles|Pink Floyd' | wc -l
find -printf "%f\n"|awk '{if($1=="Beatles") print $0}{ if ($1=="Pink") print $0}'

