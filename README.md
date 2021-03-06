Scripts to configure iptables on SageMathCloud host servers.

##### restart.sh
Flush all existing rules and reload whitelist. Run this at startup and after modifying the whitelist.

##### ip_blacklist, ip_whitelist 
These files contain one IP address per line that will be blocked/allowed. Comments must start with # and be on their own line.

##### blacklist.sh
Inserts rules from the blacklist and whitelist that prevent forwarding from the 192.168.122.0/24 network to the external network, so only traffic from VMs will be blocked.

##### reload_default_rules.sh
Flush all current iptables rules and load rules to forward traffic from VMs to the external network. 

##### vm_nat_rules
File created with iptables-save, contains rules created by libvirt for forwarding VM network to external network. This file is used by reset_iptables.sh.

