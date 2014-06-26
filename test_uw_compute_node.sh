#!/bin/bash

# number of ping packets
NPING=2

# exit script if any of the following test fail
set -e

echo -e "\n########## Ping localhost"
ping -q -c $NPING 127.0.0.1
ping -q -c $NPING 127.0.1.1

echo -e "\n########## Ping KVM host"
ping -q -c $NPING 192.168.122.1

echo -e "\n########## Ping UW host in Padelford DC"
ping -q -c $NPING cloud1.sagedev.org

echo -e "\n########## Ping UW host in 4545 DC"
ping -q -c $NPING cloud10.sagedev.org

echo -e "\n########## Ping GCE compute nodes over Tinc"
ping -q -c $NPING 10.3.1.5
ping -q -c $NPING 10.3.5.5

echo -e "\n########## Ping UW hosts over Tinc"
ping -q -c $NPING 10.1.2.1
ping -q -c $NPING 10.1.14.1

echo -e "\n##########  Test port forwarding on UW hosts"
# nc -zv cloud10.sagedev.org 2222
# nc -zv cloud1.sagedev.org 2222

# test rejection of connections to an arbitrary internet address

echo -e "\n########## Check ssh port on GCE devel node over public ip address"
nc -zv 107.178.213.222 22

echo -e "\n########## Ping a website on the whitelist"
ping -q -c $NPING 199.27.79.175


echo -e "\n########## All tests succeeded!"
