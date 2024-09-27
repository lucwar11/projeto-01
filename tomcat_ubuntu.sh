#!/bin/bash

# Define the hosts entries to add
HOSTS_ENTRIES="
#vagrant hosts
192.168.56.15 db01
192.168.56.14 mc01
192.168.56.16 rmq01
192.168.56.12 app01
192.168.56.11 web01
"

# Backup the original /etc/hosts
cp /etc/hosts /etc/hosts.bak

# Check if the entries already exist in /etc/hosts
if grep -q "192.168.56.15 db01" /etc/hosts; then
    echo "Entries already exist in /etc/hosts. No changes made."
else
    # Add the new entries to /etc/hosts
    echo "$HOSTS_ENTRIES" | sudo tee -a /etc/hosts > /dev/null
    echo "Entries added to /etc/hosts."
fi

sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-8-jdk -y
sudo apt install tomcat8 tomcat8-admin tomcat8-docs tomcat8-common git -y
