#!/bin/bash

if [[ ${#} -ne 2 ]]
    then echo "You shoud give file and dir"
    exit 1
fi

file=$1
dir=$2

grepByPattern()
{
pattern=$1
line=$2

result=$(grep "$pattern" $line | cut -d':' -f2 | cut -d' ' -f2)
echo $result
}

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" >> $file
find "$dir" -type f -regex '.*\.log$' | while IFS= read -r line
do
    echo "eho"
    host=$(basename $line .log)
    phy=$(grepByPattern "Maximum Physical Interfaces" $line)
    vlans=$(grepByPattern "VLANs" $line)
    hosts=$(grepByPattern "Hosts" $line)
    fail=$(grepByPattern "Failover" $line)
    vpn=$(grepByPattern "VPN-" $line)
    peers=$(grepByPattern "VPN Peers" $line)
    VlanTrunk=$(grepByPattern "VLAN Trunk" $line)
    license=$(grep "license" $line | cut -d' ' -f5-)
    sn=$(grepByPattern "Serial Number" $line)
    key=$(grepByPattern "Running Activation Key" $line)

    echo "$host,$phy,$vlans,$hosts,$fail,$vpn,$peers,$VlanTrunc,$license,$sn,$key" >> $file


done
