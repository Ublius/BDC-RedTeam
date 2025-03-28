#!/bin/bash

# Get IP Address
ip_address=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')

if [[ -z "$ip_address" ]]; then
	echo "No IP Address found for eth0"
else
	echo "Your IP Address Is: $ip_address"
fi
