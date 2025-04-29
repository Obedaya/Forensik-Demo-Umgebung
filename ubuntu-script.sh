#!/bin/bash

# Install apache
sudo apt update
sudo apt install apache2 -y

# Start apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Only allow in network
sudo echo "<Directory /var/www/html>
    Require ip 192.168.56.0/24
</Directory>" >> /etc/apache2/sites-available/000-default.conf

sudo systemctl reload apache2

# Configure firewall
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw allow from 192.168.56.0/24 to any port 80
sudo ufw allow out 80/tcp
sudo ufw allow out 443/tcp
sudo ufw allow out 22/tcp
sudo ufw allow out 2222/tcp
sudo ufw allow 2222/tcp
sudo ufw allow 22/tcp

echo "y" | sudo ufw enable

# Configure Website
sudo cp captcha-verify-v9.html /var/www/html/index.html

sudo systemctl reload apache2
