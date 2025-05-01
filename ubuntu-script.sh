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
sudo ufw allow from 192.168.56.0/24 to any port 80
sudo ufw allow 22/tcp

echo "y" | sudo ufw enable

# Configure Website
sudo cp captcha-verify-v9.html /var/www/html/index.html

# Create downloads directory
sudo mkdir -p /var/www/html/downloads

# Move and secure files
FILES=("python_3-4_runtime_idle.txt" "RC72LA_driver-7-updater.zip")

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Moving $file to downloads"
        sudo mv "$file" /var/www/html/downloads/
        sudo chown www-data:www-data "/var/www/html/downloads/$file"
        sudo chmod 644 "/var/www/html/downloads/$file"
    else
        echo "Warning: $file not found in current directory - download will be missing"
    fi
done

# Create basic directory listing (optional)
echo "<h1>Downloads</h1><ul>" | sudo tee /var/www/html/downloads/index.html >/dev/null
for file in "${FILES[@]}"; do
    echo "<li><a href='$file'>$file</a></li>" | sudo tee -a /var/www/html/downloads/index.html >/dev/null
done
echo "</ul>" | sudo tee -a /var/www/html/downloads/index.html >/dev/null

sudo systemctl reload apache2
