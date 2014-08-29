#! /bin/sh


function replaceVars() {
	CREDS=`cat /vagrant/credentials 2>/dev/null`
	if [ -n "$CREDS" ]; then
		CREDS="${CREDS}@"
	fi
	echo "$1 -> $2"
	cat "$1" | \
	sed -e "s/CREDENTIALS@/${CREDS}/g" > "$2"
}

replaceVars /vagrant/setup/fit14.repo /etc/yum.repos.d/fit.repo
replaceVars /vagrant/setup/fit14-devel.repo /etc/yum.repos.d/fit-devel14.repo
cp /vagrant/setup/motd /etc/motd


yum update -y
yum install bash-completion vim wget git nc bind-utils traceroute tcpdump acpid strace -y

# fit
rpm --import /vagrant/setup/sevenval.key
yum install fit14fitserver -y

/opt/sevenval/fit14/lib/fit/bin/createCertificate.sh local14.sevenval-fit.com

# disable init, is handled in 2nd provisioner
chkconfig fit14apache off
chkconfig fit14phpfpm off

function install_fit() {
	cp "/vagrant/setup/`basename "$1"`" "/opt/sevenval/fit14/conf/$1"
	chown fit:fit-data "/opt/sevenval/fit14/conf/$1"
	chmod 640 "/opt/sevenval/fit14/conf/$1"
}

install_fit domains.xml
install_fit fpm.d/fpmlimits.conf
install_fit include.global/limits.conf
install_fit fit.ini.d/devel.ini

if [ -f /opt/sevenval/fit14/conf/php-fpm.conf.rpmnew ]; then 
	mv /opt/sevenval/fit14/conf/php-fpm.conf.rpmnew  /opt/sevenval/fit14/conf/php-fpm.conf
fi

/opt/sevenval/fit14/bin/fitadmin config generate

cp /opt/sevenval/fit14/conf/fpm.d/fpmstatus.conf.example /opt/sevenval/fit14/conf/fpm.d/fpmstatus.conf


echo '# DO NOT EDIT' > /etc/profile.d/fit14.sh
echo 'export PATH=/opt/sevenval/fit14/bin/:/opt/sevenval/fit14/sbin/:$PATH' >> /etc/profile.d/fit14.sh
echo 'alias vi=vim' >> /etc/profile.d/fit14.sh



echo *************************************************
echo 
echo Local FIT 14 developer setup complete.
echo 
echo *************************************************
