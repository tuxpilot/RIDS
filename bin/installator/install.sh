#!/bin/bash

echo "WARNING!!!  THIS INSTALL will MODIFY your current installation by INSTALLING : "
echo "aplay ffmpeg git python3 mariadb-common apache2 raspi-gpio"
echo "IF and only IF you wish to continue, because you are aware that it will not disturb your configuration, enter 'YES', otherwize, write 'NO' and do this installation on a device that will accept this configuration."
echo "It is STRONGLY recomanded to do this install on a dedicated device !"
read firstack
if [[ "${firstack}" -eq 'NO' || "${firstack}" -eq 'no' || "${firstack}" -eq 'No' || "${firstack}" -eq 'nO' ]]
then  exit
fi
cd /opt/
git clone https://github.com/tuxpilot/RIDS.git

cd /opt/rids/bin
cp central.service /etc/systemd/system
cp arduino_capture.service /etc/systemd/system
cp rfid_reader.service /etc/systemd/system
chmod +x /etc/systemd/system/central.service
chmod +x /etc/systemd/system/rfid_reader.service
chmod +x /etc/systemd/system/arduino_capture.service
cd /etc/systemd/system/

READWRITEPASSWORD=$(openssl rand -base64 27)
READONLYPASSWORD=$(openssl rand -base64 27)

mysql -u root -e "show databases;" > /dev/null 2>&1
if [[ "${?}" -eq 1 ]]
then  echo 'It appears that the root account for mysql is password protected. Please enter the password for the Mysql root account'
      read sql_root_pswd
      mysql -u root -e "CREATE DATABASE rids;" -p"${sql_root_pswd}"
      mysql -u root -e "GRANT ALL PRIVILEGES ON rids.* TO 'alarm_read_write'@'localhost' IDENTIFIED BY '${READWRITEPASSWORD}';" -p"${sql_root_pswd}"
      mysql -u root -e "GRANT SELECT ON rids.* TO 'alarm_read_only'@'localhost' IDENTIFIED BY '${READONLYPASSWORD}';" -p"${sql_root_pswd}"
      mysql -u root -e "FLUSH PRIVILEGES;" -p"${sql_root_pswd}"
      mysql -u root < default_rids.sql -p"${sql_root_pswd}"
else
  mysql -u root -e "CREATE DATABASE rids;"
  mysql -u root -e "GRANT ALL PRIVILEGES ON rids.* TO 'alarm_read_write'@'localhost' IDENTIFIED BY '${READWRITEPASSWORD}';"
  mysql -u root -e "GRANT SELECT ON rids.* TO 'alarm_read_only'@'localhost' IDENTIFIED BY '${READONLYPASSWORD}';"
  mysql -u root -e "FLUSH PRIVILEGES;"
  mysql -u root < default_rids.sql
fi

echo "ropswd ${READONLYPASSWORD}" >> /opt/rids/creds.dat 2>&1
echo "ropswd ${READONLYPASSWORD}" >> /opt/rids/creds.dat 2>&1
echo "dbname rids" >> /opt/rids/creds.dat 2>&1



cp db-rw-connect.php /opt/rids/alarm_webui
cp db-ro-connect.php /opt/rids/alarm_webui
sed -i 's/ROTBD_pass/${READONLYPASSWORD}/g' /opt/rids/alarm_webui/db-ro-connect.php
sed -i 's/RWTBD_pass/${READWRITEPASSWORD}/g' /opt/rids/alarm_webui/db-rw-connect.php

ln -s /opt/rids/alarm_webui /var/www/rids
ln -s /opt/rids/cctv_captures /opt/rids/alarm_webui/cctv_captures
ln -s /opt/rids/language /opt/rids/alarm_webui/language


openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /etc/ssl/private/rids.crt \
            -keyout /etc/ssl/private/rids.key \
            -subj "/C=EU/ST=Earth/L=Earth/O=HomeSecurity/OU=RIDS/CN=localrids"

sed -i '/dtparam=spi=o/c\dtparam=spi=on' /boot/config.txt
apt update -y
apt install aplay ffmpeg git python3 mariadb-common apache2 raspi-gpio -y


cd /tmp
git clone https://github.com/lthiery/SPI-Py.git
cd /tmp/SPI-Py
python setup.py install
cd /tmp
git clone https://github.com/EspaceRaspberryFrancais/RFID-RC522.git
cd RFID-RC522
pip3 install pi-rc522


sed -i "/Listen 443/a Listen 8766" /etc/apache2/ports.conf

cp rids.conf /etc/apache2/sites-enabled/

a2enmod ssl
a2ensite /etc/apache2/sites-available/rids.conf

systemctl restart apache2
systemctl enable central.service
systemctl enable rfid_reader.service
systemctl enable arduino_capture.service

chmod +x /opt/rids/*.sh -R
echo '0  23   * * *   root    cd /opt/rids/ && ./rids_daily_maintenance.sh' >> /etc/crontab
