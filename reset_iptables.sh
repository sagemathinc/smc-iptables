#!/bin/bash

iptables -F

iptables-restore < vm_nat_rules