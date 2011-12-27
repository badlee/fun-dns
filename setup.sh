#!/bin/sh

echo "Fun_Dns setup, Do you want"
echo "   1) Install"
echo "   2) remove"
echo "   3) exit"
read case;

case $case in
1)
	if [ -d /opt/fun_dns]
	then
		rm -fr /opt/fun_dns
	fi
	mkdir /opt/fun_dns
	cd `dirname "$0"`
	cp -r ./* /opt/fun_dns
	#tar xvf /path/to/fun_dns.tar.gz
	ln -s /opt/fun_dns/fun_dns.daemon /etc/init.d/fun_dns
	update-rc.d fun_dns defaults
	#Start service
	service fun_dns start
	;;	
2)
	service fun_dns stop
	update-rc.d -f  fun_dns remove
	rm /etc/init.d/fun_dns
	cd /
	rm -fr /opt/fun_dns
	;;
3)	exit
esac
