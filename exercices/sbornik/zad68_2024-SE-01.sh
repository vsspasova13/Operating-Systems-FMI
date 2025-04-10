
#!/bin/bin

arguments=${@}

words=$(mktemp)
files=$(mktemp)

for arg in $arguments
do

if [[ "$arg" =~ ^-R ]]; then
    echo $arg | cut -c3-  >> $words
elif [[ -f $arg ]]; then
    echo $arg >> $files
fi

done

replaceWords()
{

tempFile=$1
myFile=$2

while IFS="=" read -r keyy value
do

sed -i "s/$keyy/$value/g" "$myFile"

done < "$tempFile"

}

editFile()
{

file=$1
pas=$(mktemp)

while IFS="=" read -r key val
do

    res=$(grep "\b$key\b" "$file")

    if [[ -z "$res" || "$res" =~ ^# ]]
        then continue
    else unique=$(pwgen 10 1)
         sed -i "s/$key/$unique/g" "$file"
         echo "$unique=$val" >> $pas
    fi

done < "$words"

replaceWords "$pas" "$file"

}

while IFS= read -r file
do
    echo "before: "
    cat "$file"
    editFile "$file"
    echo "after: "
    cat "$file"

done < $files
