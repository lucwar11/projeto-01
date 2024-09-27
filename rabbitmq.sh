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

sudo yum install epel-release -y
sudo yum update -y
sudo yum install wget -y
cd /tmp/
dnf -y install centos-release-rabbitmq-38
 dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
 systemctl enable --now rabbitmq-server
 firewall-cmd --add-port=5672/tcp
 firewall-cmd --runtime-to-permanent
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server
