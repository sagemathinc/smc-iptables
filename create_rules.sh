#!/bin/bash

whitelist=ip_whitelist

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

# block all non-whitelisted traffic originating from VMs
iptables -v -A FORWARD -s 192.168.122.0/24 -j REJECT --reject-with icmp-net-prohibited

# forward port 2222 to compute node
./forward_ssh_compute.sh



# allow access to http/https on UW subnets (insert at beginning of chain)
#iptables -v -I OUTPUT -d 128.208.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -v -I OUTPUT -d 128.95.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT