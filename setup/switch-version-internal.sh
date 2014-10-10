#!/bin/bash

set -e

echo "switching FIT installation to $1"
REMOVE="`rpm -qa | grep ^fit14`" || true
if [ -n "$REMOVE" ]; then
	rpm -e $REMOVE
fi
yum clean all --disablerepo=* --enablerepo=fit14*
yum-config-manager --quiet --disable fit14* >/dev/null
yum-config-manager --quiet --enable $1 >/dev/null
yum install fit14fitserver 
cd /opt/sevenval/fit14/conf
for i in *; do
	if [ -f "$i.rpmsave" ]; then
		mv "$i.rpmsave" $i
	fi
done
/opt/sevenval/fit14/bin/fitadmin config generate
/opt/sevenval/fit14/sbin/apachectl start
/opt/sevenval/fit14/sbin/phpfpmctl start

/vagrant/setup/which-version.sh
