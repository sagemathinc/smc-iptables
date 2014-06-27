#!/bin/bash

iptables -F
. create_rules_compute_node.sh
. create_rules_uid_whitelist.sh
