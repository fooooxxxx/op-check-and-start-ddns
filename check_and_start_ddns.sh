#!/bin/bash

# https://openwrt.org/docs/guide-user/services/ddns/client

if [[ -z $1 ]]; then 
    echo "Usage: $0 <service_name>"
    exit 1
fi

# check ddns status
status=$(pgrep -f -a "dynamic_dns_updater.*\b"+$1+"\b")

if [[ -z $status ]]; then
    /usr/lib/ddns/dynamic_dns_updater.sh -S $1 start &
fi
exit 0
