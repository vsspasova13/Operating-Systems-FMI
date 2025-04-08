#!/bin/bash

name=$1

if [[ -z $name ]]
    echo "You shoud give device name"
    exit 1
fi

if grep -P "$name\s+.*\*enabled" /proc/acpi/wakeup
    then $name > /proc/acpi/wakeup
    echo "Device $name is now disabled"
else echo "Device $name is not found or already disabled"
fi
