#!/bin/sh

# Make sure only root can run our script
if test "`id -u`" -ne 0
then
	echo "You need to run setup as root!"
	exit 1
fi

echo "Fun_Dns 0.1.12 setup, Do you want"
echo "\t1) Install"
echo "\t2) Remove"
echo "\t*) Exit"
read case;

case $case in
1)
	if [ -d /opt/fun_dns ]
	then
		echo "An other install exist remove it and run this script!"
		echo "For remove run"
		echo "\t - /opt/fun_dns/setup.sh as root"
		echo "\t - Enter 2 (for remove)"
		echo "\t - And press ENTER"
		exit 2
	fi
	echo  "Start install"
	mkdir /opt/fun_dns
	cd /opt/fun_dns
	echo  "Get fun_dns.v0.1.12.tar.gz "
	wget -O fun_dns.v0.1.12.tar.gz https://github.com/downloads/badlee/fun-dns/fun_dns.v0.1.12.tar.gz
	echo "Done"
	echo -n "Install fun_dns v0.1.12 : ";
	tar xvf fun_dns.v0.1.12.tar.gz
	rm fun_dns.v0.1.12.tar.gz
	ln -s /opt/fun_dns/fun_dns.daemon /etc/init.d/fun_dns
	update-rc.d fun_dns defaults
	echo "Done"
	#Start service
	echo "Start fun_dns"
	service fun_dns start
	echo "fun_dns is installed"
	;;	
2)
	echo "Stop fun_dns"
	service fun_dns stop
	echo "Uninstall fun_dns"
	update-rc.d -f  fun_dns remove
	rm -fr /etc/init.d/fun_dns
	cd /var/log
	rm -fr fun_dns.log
	rm -fr /opt/fun_dns
	echo "fun_dns is uninstalled"
	;;
3)	exit
esac