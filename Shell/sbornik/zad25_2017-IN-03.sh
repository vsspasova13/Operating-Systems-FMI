
#!/bin/bash

findNewerFile(){
home=$1

if [[ ! -d $home ]]
    then echo "no such directory!"
    return
fi

recent=$(find "$home" -type f -exec stat --format='%Y %n' {} + 2>/dev/null | sort -n | head -n1)

if [[ -z $recent ]]
    then echo "no files found in $home"
    return
fi

echo $recent
}

cut -d':' -f1,6 /etc/passwd | while IFS=':' read -r  user home
do

if [[ -z $home ]] || [[ ! -d $home ]]
    then continue
fi

recent=$(findNewerFile $home)

if [[ -n $recent ]]
    then echo "user: $user, most recent file: $recent"
fi
done | sort -n | head -n1
