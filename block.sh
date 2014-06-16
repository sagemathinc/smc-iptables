#!/bin/bash

blacklist=ip_blacklist
whitelist=ip_whitelist

# block ip addresses in blacklist file
while read -r ip
do
    # skip comments
    [[ $ip = \#* ]] && continue

    # skip empty lines
    [[ -z "${ip}" ]] && continue

    # append rule
    iptables -v -I FORWARD -s 192.168.122.0/24 -d $ip -j DROP
done < "$blacklist"


# block access to UW subnets (insert at start of chain)
iptables -v -I FORWARD -s 192.168.122.0/24 -d 128.208.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 128.95.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited


# allow ip addresses in whitelist file (insert at start of chain)
while read -r ip
do
    # skip comments
    [[ $ip = \#* ]] && continue

    # skip empty lines
    [[ -z "${ip}" ]] && continue

    # append rule
    iptables -v -I FORWARD -s 192.168.122.0/24 -d $ip -j ACCEPT
done < "$whitelist"



# allow access to http/https on UW subnets (insert at beginning of chain)
#iptables -v -I OUTPUT -d 128.208.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -v -I OUTPUT -d 128.95.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT