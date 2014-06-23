#!/bin/bash

vm_name=compute
vm_network=192.168.122.0/24
host_port=2222
destination_port=22
lease_file=/var/lib/libvirt/dnsmasq/default.leases

# need host's public ip address, this uses sagedev.org domain
# so those addresses need to be correct
host_fqdn=$HOSTNAME.sagedev.org
host_ip=$(dig +short $host_fqdn)

# quit if host lookup failed
if [ $? -ne 0 ]; then
    echo "Error: Error resolving IP address for ${host_fqdn}." 
    exit 1
fi

# search dnsmasq lease file for vm
lease_info=$(egrep "$vm_name" $lease_file)

# quit with error code if search failed
if [ $? -ne 0 ]; then
    echo "Error: IP address not found for VM $vm_name." 
    exit 2
fi

# extract ip address from lease information
destination_ip=$(echo $lease_info | awk '{ print $3 }' )

echo "Host IP is $host_ip, forwarding port $host_port to $destination_ip:$destination_port."

# allow forwarding to vm network
iptables -v -I FORWARD -m state -d $vm_network --state NEW,RELATED,ESTABLISHED -j ACCEPT

# forward port from host to vm
iptables -v -t nat -I PREROUTING -p tcp -d $host_ip --dport $host_port -j DNAT --to-destination $destination_ip:$destination_port