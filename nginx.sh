# adding repository and installing nginx	

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

apt update
apt install nginx -y
cat <<EOT > vproapp
upstream vproapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}

EOT

mv vproapp /etc/nginx/sites-available/vproapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

#starting nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
