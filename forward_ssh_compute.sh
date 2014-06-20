#!/bin/bash

vm_name=compute
vm_network=192.168.122.0/24
host_port=2222
destination_port=22
lease_file=/var/lib/libvirt/dnsmasq/default.leases

# search dnsmasq lease file for vm
lease_info=$(egrep "$vm_name" $lease_file)

# quit with error code if search failed
if [ $? -ne 0 ]; then
    echo "Error: IP address not found for VM $vm_name." 
    exit 1
fi

# extract ip address from lease information
destination_ip=$(echo $lease_info | awk '{ print $3 }' )

echo "Forwarding host port $host_port to $destination_ip:$destination_port."

# allow forwarding to vm network
iptables -v -I FORWARD -m state -d $vm_network --state NEW,RELATED,ESTABLISHED -j ACCEPT

# forward port from host to vm
iptables -v -t nat -I PREROUTING -p tcp -d $HOSTNAME.sagedev.org --dport $host_port -j DNAT --to-destination $destination_ip:$destination_port