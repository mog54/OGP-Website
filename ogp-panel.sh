#!/bin/bash

IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install apache2 curl subversion php5 php5-gd php5-xmlrpc php5-curl php5-mysql php-pear mysql-server libapache2-mod-php5 git zip -y
cd /var/www/html/
rm index.html
wget https://github.com/OpenGamePanel/OGP-Website/archive/master.zip
unzip master.zip
mv OGP-Website-master/* /var/www/html/
rm master.zip 
rm -d OGP-Website-master/
rootpasswd=root
mysql_password=panel
mysql -u root -p$rootpasswd -e "CREATE DATABASE panel; CREATE USER 'panel'@'localhost' IDENTIFIED BY '$mysql_password'; GRANT ALL PRIVILEGES ON panel.* TO 'panel'@'localhost'; FLUSH PRIVILEGES;"
chown -R www-data:www-data /var/www/html/
echo "upload_max_filzsize = 20M" >> /etc/php5/apache2/php5.ini
service apache2 restart

echo "http://$IP"
echo "rm /var/www/html/install.php && chmod 0644 /var/www/html/includes/config.inc.php"
