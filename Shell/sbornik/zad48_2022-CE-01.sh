#!/bin/bash

num=$1
pref=$2
unit=$3

line=$(grep ",$pref," "prefix.csv")
scalar=$(echo $line | cut -d',' -f3)

num=$(echo "scale=2; 2.1 * $scalar" | bc)

line2=$(grep ",$unit," "base.csv")
unitName=$(echo $line2 | cut -d',' -f1)
measure=$(echo $line2 | cut -d',' -f3)

echo "$num $unit ($measure, $unitName)"
