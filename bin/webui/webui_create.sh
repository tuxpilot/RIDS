#!/bin/bash

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

mysql -u root -e "DATABASE CREATE rids;"
mysql -u root -e "GRANT ALL ON rids.* TO 'alarm_read_write'@'localhost' IDENTIFIED BY '${READWRITEPASSWORD}';"
mysql -u root -e "GRANT SELECT ON rids.* TO 'alarm_read_only'@'localhost' IDENTIFIED BY '${READONLYPASSWORD}';"
mysql -u root < default_rids.sql

sed -i 's/ROTBD_pass/${READONLYPASSWORD}/g' db-ro-connect.php 
sed -i 's/RWTBD_pass/${READWRITEPASSWORD}/g' db-rw-connect.php 

ln -s /opt/rids/alarm_webui /var/www/rids
ln -s /opt/rids/cctv_captures /opt/rids/alarm_webui/cctv_captures


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
apt install omxplayer ffmpeg git python3 mariadb-common apache2 -y


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

