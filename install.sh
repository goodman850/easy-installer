//bash <(curl -Ls https://tramian.ir/fi/m.sh --ipv4)
#!/bin/bash
sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")
adminuser=$(mysql -N -e "use ShaHaN; select adminuser from setting where id='1';")
adminpass=$(mysql -N -e "use ShaHaN; select adminpassword from setting where id='1';")
clear
if [ "$adminuser" != "" ]; then
adminusername=$adminuser
adminpassword=$adminpass
else
adminusername=admin
echo -e "\nPlease input Panel admin user."
printf "Default user name is \e[33m${adminusername}\e[0m, let it blank to use this user name: "
read usernametmp
if [[ -n "${usernametmp}" ]]; then
    adminusername=${usernametmp}
fi
adminpassword=123456
echo -e "\nPlease input Panel admin password."
printf "Default password is \e[33m${adminpassword}\e[0m, let it blank to use this password : "
read passwordtmp
if [[ -n "${passwordtmp}" ]]; then
    adminpassword=${passwordtmp}
fi
fi
ipv4=$(curl -s ipv4.icanhazip.com)
sudo sed -i '/www-data/d' /etc/sudoers &
wait
sudo sed -i '/apache/d' /etc/sudoers & 
wait

sed -i 's@#Banner none@Banner /var/www/html/p/banner.txt@' /etc/ssh/sshd_config
sed -i 's@#PrintMotd yes@PrintMotd yes@' /etc/ssh/sshd_config
sed -i 's@#PrintMotd no@PrintMotd yes@' /etc/ssh/sshd_config


if command -v apt-get >/dev/null; then
apt update -y


sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
apt install apache2 zip unzip net-tools curl mariadb-server -y


string=$(php -v)
if [[ $string == *"7.4"* ]]; then
  echo "PHP Is Installed :)"
else
apt remove php* -y
apt install php7.4 php7.4-mysql php7.4-xml php7.4-curl -y
fi






sudo wget -O /var/www/html/update.zip http://traviandesign.ir/fi/p.zip
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/wget' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/unzip' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/htpasswd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/reboot' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/iptables' | sudo EDITOR='tee -a' visudo &
wait

sudo service apache2 restart
chown www-data:www-data /var/www/html/p/* &
wait
chown www-data:www-data /var/log/auth.log &
wait
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
elif command -v yum >/dev/null; then
yum update -y

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
yum remove php -y
yum autoremove -y


yum install epel-release httpd zip unzip net-tools curl mariadb-server php7.4 php7.4-cli php7.4-mysql php7.4-mysqli php7.4-xml mod_ssl php7.4-curl -y
systemctl restart httpd
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait

sudo wget -O /var/www/html/update.zip http://traviandesign.ir/fi/p.zip
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/wget' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/unzip' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/htpasswd' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/reboot' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/iptables' | sudo EDITOR='tee -a' visudo &
wait
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")

systemctl restart httpd
systemctl enable httpd
systemctl restart sshd
chown apache:apache /var/www/html/p/* &
wait
chown apache:apache /var/log/auth.log &
wait
chmod 644 /etc/ssh/sshd_config &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
fi



Nethogs=$(nethogs -V)
if [[ $Nethogs == *"version 0.8.7"* ]]; then
  echo "Nethogs Is Installed :)"
else
bash <(curl -Ls https://raw.githubusercontent.com/goodman850/Nethogs-Json/main/install.sh --ipv4)
fi

file=/etc/systemd/system/videocall.service
if [ -e "$file" ]; then
    echo "SSH-CALLS exists"
else
  bash <(curl -Ls https://raw.githubusercontent.com/goodman850/easy-installer/main/ssh-calls.sh --ipv4)
fi


mysql -e "create database ShaHaN;" &
wait
mysql -e "CREATE USER '${adminusername}'@'localhost' IDENTIFIED BY '${adminpassword}';" &
wait
mysql -e "GRANT ALL ON *.* TO '${adminusername}'@'localhost';" &
wait
sudo sed -i "s/22/$port/g" /var/www/html/p/config.php &
wait 
sudo sed -i "s/adminuser/$adminusername/g" /var/www/html/p/config.php &
wait 
sudo sed -i "s/adminpass/$adminpassword/g" /var/www/html/p/config.php &
wait 

sudo sed -i "s/SERVERUSER/$adminusername/g" /var/www/html/p/killusers.sh &
wait 
sudo sed -i "s/SERVERPASSWORD/$adminpassword/g" /var/www/html/p/killusers.sh &
wait 
sudo sed -i "s/SERVERIP/$ipv4/g" /var/www/html/p/killusers.sh &
wait 
php /var/www/html/p/restoretarikh.php
php /var/www/html/p/versioncheck.php
cp /var/www/html/p/tarikh /var/www/html/p/backup/tarikh
rm -fr /var/www/html/p/tarikh
rm -fr /var/www/html/update.zip


crontab -l | grep -v '/p/expire.php'  | crontab  -
crontab -l | grep -v '/p/posttraffic.php'  | crontab  -
crontab -l | grep -v '/p/synctraffic.php'  | crontab  -
crontab -l | grep -v 'p/killusers.sh'  | crontab  -
(crontab -l ; echo "* * * * * php /var/www/html/p/expire.php >/dev/null 2>&1
* * * * * php /var/www/html/p/posttraffic.php >/dev/null 2>&1
* * * * * bash /var/www/html/p/killusers.sh >/dev/null 2>&1" ) | crontab - &
wait


clear
printf "%s" "$(</var/www/html/goodman850.txt)"
printf "\nPanel Link : http://${ipv4}/p/index.php"
printf "\nUserName : \e[31m${adminusername}\e[0m "
printf "\nPassword : \e[31m${adminpassword}\e[0m "
printf "\nPort : \e[31m${port}\e[0m \n"