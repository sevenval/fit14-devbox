
set -e  

trap 'echo "ERROR: could not install new FIT packages. try switching back to stable by running
	switch-version.sh stable"' SIGINT SIGTERM

VERSION=$1
CHANNEL=fit14${VERSION#14}

#27343 read credentials for beta users
CREDENTIALS=$(cat /vagrant/credentials 2>/dev/null)
if [ -n "$CREDENTIALS" ]; then
	CREDENTIALS="${CREDENTIALS}@"
fi

echo "switching FIT installation to $VERSION"
REMOVE="`rpm -qa | grep ^fit14`" || true
if [ -n "$REMOVE" ]; then
	rpm -e $REMOVE
fi

yum clean all --disablerepo=* --enablerepo=fit14* || true
yum-config-manager --quiet --disable "fit14*" >/dev/null

rm -f /etc/yum.repos.d/fit14-tmp.repo

if ! yum-config-manager --disablerepo=* --enablerepo=${CHANNEL} 2>&1 >/dev/null; then

	echo "[${CHANNEL}]
name = Sevenval FIT Server 14 Channel ${CHANNEL}
baseurl = https://${CREDENTIALS}download.sevenval-fit.com/FIT_Server_Beta/14/packages/RHEL/7/${VERSION}/x86_64
enabled = 1
gpgkey = https://download.sevenval-fit.com/FIT_Server/sevenval.key
gpgcheck = 0
proxy = _none_" > /etc/yum.repos.d/fit14-tmp.repo
fi

yum-config-manager --quiet --enable ${CHANNEL} >/dev/null
yum --disableplugin=fastestmirror install -y fit14fitserver

#27343 don't store credentials inside the box
sed -i '/baseurl.*@/ s/https:\/\/.*\?@/https:\/\//' /etc/yum.repos.d/fit14-tmp.repo

cd /opt/sevenval/fit14/conf

for i in $(find /opt/sevenval/fit14/conf -type f -name \*.rpmsave); do
	mv $i ${i%.rpmsave}
	echo "* restoring changed config file /opt/sevenval/fit14/conf/${i}"
done

/opt/sevenval/fit14/bin/fitadmin config generate
/opt/sevenval/fit14/sbin/apachectl start
/opt/sevenval/fit14/sbin/phpfpmctl start

/vagrant/setup/which-version.sh
