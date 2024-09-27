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

sudo dnf install epel-release -y
sudo dnf install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d
