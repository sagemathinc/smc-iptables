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
iptables -v -I FORWARD -s 192.168.122.0/24 -d 192.42.145.0/24 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 198.48.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 192.26.136.0/24 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 140.142.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 205.175.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 69.91.128.0/17 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 108.179.128.0/18 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 173.250.128.0/17 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited

iptables -v -I FORWARD -s 192.168.122.0/24 -d 65.212.179.160/27 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 65.61.117.128/27 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 66.45.176.184/29 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 66.45.163.112/28 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 23.25.134.216/29 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 173.160.204.24/29 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited

# block access to all private networks, access must be explicitely allowed after this rule.
iptables -v -I FORWARD -s 192.168.122.0/24 -d 172.16.0.0/12 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 192.168.0.0/16 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited
iptables -v -I FORWARD -s 192.168.122.0/24 -d 10.0.0.0/8 -m state --state NEW -j REJECT --reject-with icmp-net-prohibited


# allow libvirt-generated subnet
iptables -v -I FORWARD -s 192.168.122.0/24 -d 192.168.122.0/24 -j ACCEPT

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