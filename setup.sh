#!/bin/bash
cwd=`pwd`
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ ! -f creds.py ]; then
	apt-get update
	apt-get install  libasound2-dev memcached python-pip mpg123 python-alsaaudio
	pip install -r requirements.txt
	cp initd_alexa.sh /etc/init.d/alexa
	cd /etc/rc5.d
	ln -s ../init.d/alexa S99alexa
	touch /var/log/alexa.log

	cd $cwd

	echo "Enter your ProductID:"
	read productid
	echo ProductID = \"$productid\" >> creds.py

	echo "Enter your Security Profile Description:"
	read spd
	echo Security_Profile_Description = \"$spd\" >> creds.py

	echo "Enter your Security Profile ID:"
	read spid
	echo Security_Profile_ID = \"$spid\" >> creds.py

	echo "Enter your Security Client ID:"
	read cid
	echo Client_ID = \"$cid\" >> creds.py

	echo "Enter your Security Client Secret:"
	read secret
	echo Client_Secret = \"$secret\" >> creds.py
else
	echo "If you want to resetup everything, delete creds.py file"
	echo "Credentials already setup. Skipping setup and starting app..."
fi

ip = `ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
python ./auth_web.py 
echo "Open http://$ip:5000"

echo "You can now reboot"

