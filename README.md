# RIDS

> **WARNING!**
>
> - DO NOT use it as it is until the README.md says otherwize!
> - This Git repository is just a git repository!
> - This project is not to be used as a working project at all!
> - Many features and many functionnalities makes it not sure enough to be used as a reliable alarm system!

Before anything!
- Yes!!! It is messy!
- Yes it is not optimised!
- Yes it is shell!
- Yes it is PHP and not with the best practices!
- No, i'm not a developer, i'm an sysadmin and i do it on my rest time with my knowledge of scripting of being an sysadmin!
- **It is a POC!** So it will be probably optimised with a better language (like C) in the future.

# Introduction

"RIDS" stands for "Raspberry Intrusion and Detection System"

It is a home made, POC (Proof Of Concept) script, based on shell and PHP, using the GPIO (General Purpose In and Out) interfaces of the Raspberry. It has been developped on a Raspberry Pi 3b+.

The detection system rely upon detecting a changing state in the GPIOs and reading the human interactions through a RFID reader. This alarm is not yet compatible with wireless detectors such as 433Mhz wireless movements detectors and doors opening detectors : that feature is still being tested and under development. For the moment, the alarm can send SMS through the OVH SMS API only. It is a 100% wired alarm.

It can work with no internet access at all, but must be put safely behind a secured firewall. All the configuration is to be made from the Webui. For convenience and usability, all the sounds and vocal annoucements from the alarm are both in English and French, but the documentation and the configuration are in English only for the moment.

The web UI, is here to help you monitor and manage the alarm and prevent you from doing it from the CLI, enhancing the friendly user experience.

Management mode:
- Let you ADD, REMOVE and flag an RFID card as lost or stolen.
- Let you customize settings for the alarm behavior, like the temporisation of an access point before trigerring the alarm, setting the language, etc.
- Let you ADD, REMOVE and customize the GPIO dedicated to the access point you wish to monitor.

Manual arming:
 - Let you put the alarm in "ON" mode without having to pass an RFID card in contact with the reader and wait for the arming delay.

CCTV Captures: 
- Let you see the short clips a RTSP camera captured when an event was triggered.
	
Access Point Tracking: 
- Let you monitor in real time the state of every access point you declared
	
RIDS tends to get close to most of the modern alarm system you can find on the market, with functionnalities you may find on some high end and well known security systems like Genetec, Milestone, etc.

# Installation

## Hardware Prerequisites 

For the physical installation: 
- Electrical cable
- As many wired doors opening detectors
- 1 Raspberry Pi (3b, 3b+ or 4)
- 1 set of baffles
- 1 RFID MFRC522 reader 
- Jumpwires


Recommended :
- 1 UPS, so that the alarm does not shutdown if there is a loss of power
- a distant server or device that can check if the alarm is still online
- an OVH account with an SMS account so that the alarm can send SMS alerts by SMS for better reactivity
- a RTSP compatible web IP camera
- 1 RGB led


## Software installation

For the moment, the installation is fully manual, the installer will be automatic in the coming months

Logical installation : 
 1. Install any of theses GNU/Linux Distro on your Raspberry (Ubuntu, Ubuntu Server, Raspbian, etc. )
 2. Log in via a SSH client to your Raspberry
 3. Follow the following CLI commands : 

```
sudo apt install omxplayer ffmpeg git python mariadb-common
sudo vim /etc/boot/config.txt   # set dtparam=spi=on
sudo git clone https://github.com/lthiery/SPI-Py.git
cd ~/SPI-Py
sudo git checkout 8cce26b9ee6e69eb041e9d5665944b88688fca68
sudo python setup.py install
sudo cd ~
sudo git clone https://github.com/EspaceRaspberryFrancais/RFID-RC522.git
sudo cd ~/RFID-RC522
sudo pip3 install pi-rc522
sudo mysql -u root -p rids < rids_backup.sql
cd /home/pi/
sudo git clone https://github.com/tuxpilot/RIDS.git
```

## SQL database

Now you have to set up the database accounts, do not forget to customize the passwords which in the following lines are the `?????????????????????`.

### Read Only mysql account
```
sudo mysql -u root -e "GRANT SELECT ON rids.* TO 'alarm_read_only'@'localhost' IDENTIFIED BY '?????????????????????';" -p
```

### Read Write mysql account
```
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON rids.* TO 'alarm_read_write'@'localhost' IDENTIFIED BY '?????????????????????';" -p
```

### Edit the central.sh file and look for the following lines: 
```
ropswd=''
rwpswd=''
```

Inside the quotes, enter the password you entered in the myssql commands for the Read Only and the Read Write accounts

## Systemd service

### Declare RIDS and the RFID Reader as a service
```
cd RIDS
cp central.service /etc/systemd/system
cp rfid_reader.service /etc/systemd/system
chmod +x /etc/systemd/system/central.service
chmod +x /etc/systemd/system/rfid_reader.service
cd /etc/systemd/system/
systemctl enable central.service
systemctl enable rfid_reader.service
```

## Set up the WebUI

```
apt install apache2
cp /home/pi/RIDS/bin/rids.conf /etc/apache2/sites-available/
ln -s /home/pi/RIDS/alarm_webui/ /var/www/html/
a2ensite rids.conf
```

# Alarm configuraiton

Customize the alarm before getting it to work:

You will have to customize the alarm before you hope it matches the environment and your expectations. To do so, you have to get to your RIDS Web User Inteface and click on the "Enter Management Mode" icon. Refresh the page, and it should show you some more icons. Click on the "Edit the Global Settings" icon to get in the settings management page. 

Here is the list of the settings you can customize

- `language`	Let you set the language of the voice of the alarm
- `log_folder`	Let you set the folder of the log file
- `debug_file`	Let you set the name of the log file
- `default_alarm_status`	Set the alarm in the chosen mode (0 or 1) every time the alarm restart (restart from the service or restart of the entire Raspberry)
- `gpio_piezo_number`	Let you set the GPIO number where the Piezo is connected to
- `user_input_method`	Let you set the method for user authentication 
- `gpio_user_input_method_circuit_mode` Let you choose between the RFID reader authentication, or a dry contact incoming information if you have an alternate - authentication method.
- `gpio_user_input_method` Let you enter the BCM GPIO of the authentication method if you have a dry contact coming from an alternate authentication method
- `silent_alarm` Let you choose wheter you want to have a audible alarm if an intrusion is detected or you just want to be warned silently
- `silent_buzzer` Let you choose wheter you want to have the piezo active or not at all.
- `image_capture_folder` Let you set up the folder of the folder where the images will be stored if you choose to have image clips on triggered even
- `alarm_temporisation_delay` Let you set up the time to let you get out of your house after you armed the alarm.
- `alarm_siren_max_time` Let you choose the maximum time of the audio alarm to be running if an intrusion is detected (prevent the alarm to ring forever if an intrusion is detected... can be useful if you're on vacation far away and you have no way of turning it off while having neighboors who will have to listen to it until you get back...)
- `debug_activated` Let you choose if you want the debug file to be filled or not. Warning, the file get big very quickly! Warning! The debug file has no link with the event log!
- `gpio_status_led_pwr` Let you set the GPIO number where the power pin of the RGB LED is connected to
- `gpio_status_led_red` Let you set the GPIO number where the RED pin of the RGB LED is connected to
- `gpio_status_led_blue` Let you set the GPIO number where the BLUE pin of the RGB LED is connected to
- `gpio_status_led_green` Let you set the GPIO number where the GREEN pin of the RGB LED is connected to
- `gpio_status_led_enabled` Let you set wether you have a RGB LED or not
- `send_sms_on_reboot` Let you set if you want to receive a SMS if the Raspberry was restarted
- `video_capture_enabled` Set it to yes if you have a RTSP camera enabled and you want the alarm to use it
- `video_capture_timing` Let you set the length of the clips the alarm captures in the format (HH:MM:SS)
- `video_capture_password` Password of the RTSP camera 
- `video_capture_username` Username of the RTSP camera
- `video_capture_url` URL of the RTSP camera
- `video_capture_on_alert_only` Choose yes if you want the alarm to capture video clips only on alert triggered events. If "No", then the alarm captures video clips on every events (door opening even if the alarm is not armed for example)
- `trigger_alarm_on_lost_or_stolen_card` Trigger the full intrusion alarm if a lost or stolen RFID card is detected while the alarm is armed.
- `silent_voice` Let you enable or disable the voices of the alarm on every event (alarm arming, disarming, entering, management mode, etc. )

Click on the "GPIO Management" icon to get in the GPIO management page. Here is the page where you set up your access points. Every access point you connected to a GPIO needs to be set up here.

You need to enter the following informations in order to let the alarm manage it:
- Access point Name		Set up a human readable name for this access point (ie: front door)
- Access point GPIO Number	Enter the BCM GPIO number where you connected your Access point door opening detector 
- GPIO value when access point is closed	Enter the value the GPIO reads when the access point is closed
- Temporised access point?	Let you choose whether the alarm gets off immediatly if the access point is detected as open, or if you want to let some time for someone to authenticate first (ie: you may want to choose 0 for a windows since normally people don't get in your house from the window...)

# Incoming features

- Watchdog for making sure the services and the scripts are always running
- Automatic deletion of the media clips based on a retention number in days
- Automatic installation based on a script from the CLI
- Adding an Access point from the WEbui and customize it
- Add and modify the settings from the Webui
- Delete manually a video clip from the Webui
- Webui user authentication
- ADD a new access point with the assistance of the Webui (to be helped with the state of the value in open/close state, etc.)
- Manage the SMS and mail sending alarm information from the Webui
- Arm/disable the alarm based on user authentication from a USB Keyboard
- Wireless communication between the access point monitoring devices (RF :433Mhz)
- Let you choose another SMS sender than OVH (Twilio, RaspiSMS, etc.)
- Let you choose to send SMS from a dedicated device (managed automaticaly with minicom)
- Let you set multiple IP cameras to the system
- Let you monitor the stream of the IP Cameras in real time, like in a security control center.
- Let you make groups of access points inside 'zones', to be able to secure a specific perimeter while some others are not, letting you access the unprotected perimeters without triggering the whole alarm.
- Let you upload a .Jpg of a map, and let you draw the protected zones, and showing on the map the triggered zone if any, by highlighting it
- Let you add a wired 'panic button'
- Let you add a wireless 'panic button' (when the wireless communication development will be over and tested)
- Let you speak through the alarm, almost in real time, if you have loud speakers connected to the Rpi
- Let you have an alert if you choose to be warned when a door is detected as opened for more than X seconds 
