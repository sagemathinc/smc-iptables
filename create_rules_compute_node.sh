#!/bin/bash

whitelist=ip_whitelist


# allow gce default subnet
iptables -v -I OUTPUT -d 10.240.0.0/16 -j ACCEPT

# allow tinc subnets
iptables -v -I OUTPUT -d 10.1.0.0/16 -j ACCEPT
iptables -v -I OUTPUT -d 10.2.0.0/16 -j ACCEPT
iptables -v -I OUTPUT -d 10.3.0.0/16 -j ACCEPT
iptables -v -I OUTPUT -d 10.4.0.0/16 -j ACCEPT


# allow ip addresses in whitelist file (insert at start of chain)
while read -r ip
do
    # skip comments
    [[ $ip = \#* ]] && continue

    # skip empty lines
    [[ -z "${ip}" ]] && continue

    # append rule
    iptables -v -I OUTPUT -d $ip -j ACCEPT
done < "$whitelist"

# block all non-whitelisted traffic originating from VMs
iptables -v -A OUTPUT -m state --state NEW -j REJECT



# allow access to http/https on UW subnets (insert at beginning of chain)
#iptables -v -I OUTPUT -d 128.208.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -v -I OUTPUT -d 128.95.0.0/16 -p tcp -m multiports --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
