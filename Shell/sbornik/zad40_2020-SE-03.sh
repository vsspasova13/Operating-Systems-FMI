#!/bin/bash

if [[ ${#} -ne 2 ]]
	then echo "You shoud give 2 arguments!"
	exit 1
fi

repo=$1
package=$2

package=$(basename $package )

version=$(cat "$2/version")

tree="$2/tree"

archived=$(mktemp)
tar -C "$tree" -c .  | xz -c > $archived

hashh=$(sha256sum $archived| cut -d' ' -f1)

mkdir -p "$repo/packages"

cp $archived "$repo/packages/$hashh.tar.xz"

db="$repo/db"

touch $db

sed -i "/^$package-$version /d" $db
echo "$package-$version $hashh" >> $db
sort $db

