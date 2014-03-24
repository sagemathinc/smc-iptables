#!/bin/bash

filename=/root/ip_blacklist/ip_blacklist

# read each line from file into $ip
while read -r ip
do
    # skip comments
    [[ $ip = \#* ]] && continue

    # skip empty lines
    [[ -z "${ip}" ]] && continue

    # append rule
    iptables -v -A OUTPUT -d $ip -j DROP
done < "$filename"