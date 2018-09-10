#!/bin/bash

# Wordpress Auto Installer using WP-CLI for CentOS Web Panel [CWP]

# Scripted by Bullten Web Hosting Solutions [http://www.bullten.com]

set -e

wpuser=$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 7 | head -n 1)
wppass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
wpdbpass=$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 7 | head -n 1)
wpdbprefix=$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 3 | head -n 1)

RED='\033[01;31m'
RESET='\033[0m'
GREEN='\033[01;32m'

clear

echo -e "$GREEN******************************************************************************$RESET"
echo -e "   Wordpress Installation using WP-CLI in CentOS Web Panel [CWP]$RESET"
echo -e "       Bullten Web Hosting Solutions https://www.bullten.com/"
echo -e "   Web Hosting Company Specialized in Providing Managed VPS and Dedicated Server   "
echo -e "$GREEN******************************************************************************$RESET"
echo " "
echo " "

read -p "$(echo -e $GREEN"Enter Your Installation Domain Name (example.com):"$RESET) "  wpdomain
echo -e $GREEN""$RESET

mysql root_cwp<<EOF > /root/user.txt
SELECT username
FROM user
WHERE domain='$wpdomain';
EOF
cwpuser=$(cat /root/user.txt |sed -n 2p)

if [ -z "$cwpuser" ]

then

echo -e $GREEN""$RESET
echo -e $RED"Domain Doesn't Exist. Aborting Installation$RESET"
echo -e $GREEN""$RESET

else

wpdbname=$cwpuser'_'$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 7 | head -n 1)
wpdbuser=$cwpuser'_'$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 7 | head -n 1)

read -p "$(echo -e $GREEN"Enter Your Email Address (example@example.com):"$RESET) "  wpemail

echo -e $GREEN""$RESET
echo -e $GREEN"Domain Exist. Installation in Progress$RESET"
echo -e $GREEN""$RESET

if [ -e "/usr/local/bin/wp" ]

then

printf '%50s\n' | tr ' ' -
echo -e $GREEN""$RESET
echo -e $GREEN"WP-CLI Already Exist$RESET"

echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
echo -e $GREEN""$RESET
echo -e $GREEN"Database Setup in Progress$RESET"
echo -e $GREEN""$RESET

mysql <<EOF
CREATE DATABASE $wpdbname;
CREATE USER '$wpdbuser'@'localhost' IDENTIFIED BY '$wpdbpass';
GRANT ALL PRIVILEGES on $wpdbname.* to '$wpdbuser'@'localhost';
FLUSH PRIVILEGES;
EOF

sleep 5
echo -e $GREEN"Database Setup Completed$RESET"
echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
echo -e $GREEN""$RESET
echo -e $GREEN"Wordpress Setup in Progress$RESET" 
echo -e $GREEN""$RESET

wp core download --path=/home/$cwpuser/public_html --allow-root
wp core config --path=/home/$cwpuser/public_html --dbname=$wpdbname --dbuser=$wpdbuser --dbpass=$wpdbpass --dbhost=localhost --dbprefix=wp$wpdbprefix_ --allow-root
wp core install --path=/home/$cwpuser/public_html --url="$wpdomain" --title="New Wordpress Blog" --admin_user="$wpuser" --admin_password="$wppass" --admin_email="$wpemail" --allow-root

echo -e $GREEN""$RESET
echo -e $GREEN"Wordpress Setup Completed$RESET" 
echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
sleep 5

echo -e $GREEN""$RESET
echo -e $GREEN"Finalizing Settings$RESET"
echo -e $GREEN""$RESET

chown -R $cwpuser:$cwpuser /home/$cwpuser/public_html/*
rm -rf /root/user.txt

echo -e $GREEN"Your Wordpress Details$RESET"
echo -e $GREEN""$RESET

printf '%50s\n' | tr ' ' -


cat > /root/$wpdomain.txt <<EOF
Your Wordpress Domain Name: $wpdomain
Your Admin Email: $wpemail
Wordpress Admin Username: $wpuser
Wordpress Admin Password: $wppass
Wordpress Database Name: $wpdbname
Wordpress Database User: $wpdbuser
Wordpress Database Password: $wpdbpass
Wordpress Database Prefix: wp_$wpdbprefix
EOF

cat /root/$wpdomain.txt

echo "Your Wordpress Details are saved at: /root/$wpdomain.txt"

printf '%50s\n' | tr ' ' -

else

echo -e $GREEN""$RESET
echo -e $GREEN"Installing WP-CLI$RESET"
echo -e $GREEN""$RESET

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
echo -e $GREEN""$RESET
echo -e $GREEN"Database Setup in Progress$RESET"
echo -e $GREEN""$RESET

mysql <<EOF
CREATE DATABASE $wpdbname;
CREATE USER '$wpdbuser'@'localhost' IDENTIFIED BY '$wpdbpass';
GRANT ALL PRIVILEGES on $wpdbname.* to '$wpdbuser'@'localhost';
FLUSH PRIVILEGES;
EOF

sleep 5
echo -e $GREEN"Database Setup Completed$RESET"
echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
echo -e $GREEN""$RESET
echo -e $GREEN"Wordpress Setup in Progress$RESET" 
echo -e $GREEN""$RESET

wp core download --path=/home/$cwpuser/public_html --allow-root
wp core config --path=/home/$cwpuser/public_html --dbname=$wpdbname --dbuser=$wpdbuser --dbpass=$wpdbpass --dbhost=localhost --dbprefix=wp$wpdbprefix_ --allow-root
wp core install --path=/home/$cwpuser/public_html --url="$wpdomain" --title="New Wordpress Blog" --admin_user="$wpuser" --admin_password="$wppass" --admin_email="$wpemail" --allow-root

echo -e $GREEN""$RESET
echo -e $GREEN"Wordpress Setup Completed$RESET" 
echo -e $GREEN""$RESET
printf '%50s\n' | tr ' ' -
sleep 5

echo -e $GREEN""$RESET
echo -e $GREEN"Finalizing Settings$RESET"
echo -e $GREEN""$RESET

chown -R $cwpuser:$cwpuser /home/$cwpuser/public_html/*
rm -rf /root/user.txt

echo -e $GREEN"Save Your Wordpress Details Below$RESET"
echo -e $GREEN""$RESET

printf '%50s\n' | tr ' ' -


cat > /root/$wpdomain.txt <<EOF
Your Wordpress Domain Name: $wpdomain
Your Admin Email: $wpemail
Wordpress Admin Username: $wpuser
Wordpress Admin Password: $wppass
Wordpress Database Name: $wpdbname
Wordpress Database User: $wpdbuser
Wordpress Database Password: $wpdbpass
Wordpress Database Prefix: wp_$wpdbprefix
EOF

cat /root/$wpdomain.txt

echo "Your Wordpress Details are saved at: /root/$wpdomain.txt"

printf '%50s\n' | tr ' ' -


fi
fi
