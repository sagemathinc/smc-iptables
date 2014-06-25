#!/bin/bash

# number of ping packets
NPING=2

# exit script if any of the following test fail
set -e

echo -e "\n########## Testing DNS"
ping -q -c $NPING 169.254.169.254

echo -e "\n########## Ping UW host in Padelford DC"
ping -q -c $NPING cloud1.sagedev.org

echo -e "\n########## Ping UW host in 4545 DC"
ping -q -c $NPING cloud10.sagedev.org

echo -e "\n########## Ping GCE nodes over Google internal network"
ping -q -c $NPING 10.240.14.23
ping -q -c $NPING 10.240.84.244

echo -e "\n########## Ping GCE compute nodes over Tinc"
ping -q -c $NPING 10.3.1.5
ping -q -c $NPING 10.3.5.5

echo -e "\n########## Ping UW hosts over Tinc"
ping -q -c $NPING 10.1.2.1
ping -q -c $NPING 10.1.14.1

echo -e "\n##########  Test port forwarding on UW hosts"
nc -zv cloud10.sagedev.org 2222

# test rejection of connections to an arbitrary internet address

echo -e "\n########## Ping a website on the whitelist"
ping -q -c $NPING 199.27.79.175
