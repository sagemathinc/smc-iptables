#!/bin/bash

whitelist=uid_whitelist

# allow ip addresses in whitelist file (insert at start of chain)
while read -r uid
do
    # skip comments
    [[ $uid = \#* ]] && continue

    # skip empty lines
    [[ -z "${uid}" ]] && continue

    # append rule
    iptables -v -I OUTPUT -m owner --uid-owner $uid -j ACCEPT

done < "$whitelist"

