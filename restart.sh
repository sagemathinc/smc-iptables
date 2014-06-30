#!/bin/bash

cd /root/smc-iptables

iptables -F
. create_rules_compute_node.sh
. create_rules_uid_whitelist.sh
