#! /bin/bash -e
# ====================================================================================================

TIMEFORMAT=%R
export LANG=C

declare -i failed=0

# ====================================================================================================

sCurrentDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! "$sCurrentDir" = "/vagrant/setup" ]; then
	echo "Use '/vagrant/setup/check_internal.sh' in your VM to execute this script\n"
	echo "or run 'vagrant ssh -c /vagrant/setup/check_internal.sh'."
	exit 1
fi

# ====================================================================================================

source /vagrant/setup/functions.sh
trap _shutdown EXIT

# ====================================================================================================

sMessage="Connectivity http://example.com/ (DNS and routing)"
if $(curl -f -s --max-time 3 http://example.com/ >/dev/null); then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

sMessage="File '/etc/dhcp/dhclient.d/resolvconf.sh' does not exist"
if [ ! -f "/etc/dhcp/dhclient.d/resolvconf.sh" ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

sMessage="File '/etc/motd' exists"
if [ -f "/etc/motd" ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi


# ====================================================================================================

aCertFiles=(crt csr key)

for sCertFile in "${aCertFiles[@]}"
do
	sMessage="SSL-File 'local14.sevenval-fit.com.$sCertFile' exists"
	if [ -f "/opt/sevenval/fit14/conf/ssl/local14.sevenval-fit.com.$sCertFile" ]; then
		_printLine "$sMessage" 1
	else
		_printLine "$sMessage" 0
	fi
done

# ====================================================================================================

aConfFiles=("domains.xml" "fpm.d/fpmlimits.conf" "include.global/limits.conf" "fit.ini.d/devel.ini")

for sConfFile in "${aConfFiles[@]}"
do
	sMessage="Config file '$sConfFile' exists"
	if [ -f "/opt/sevenval/fit14/conf/$sConfFile" ]; then
		_printLine "$sMessage" 1
	else
		_printLine "$sMessage" 0
	fi

	sMessage="Owner of '$sConfFile' is 'fit/fit-data'"
	if [ `stat -c "%u:%g" /opt/sevenval/fit14/conf/$sConfFile` = "1000:1000" ]; then
		_printLine "$sMessage" 1
	else
		_printLine "$sMessage" 0
	fi

	sMessage="Permissions of '$sConfFile'"
	if [ `stat -c "%a" /opt/sevenval/fit14/conf/$sConfFile` = "640" ]; then
		_printLine "$sMessage" 1
	else
		_printLine "$sMessage" 0
	fi
done

# ====================================================================================================

iCheck=`ls /opt/sevenval/fit14/conf/vhosts/ | grep -c 'local14.sevenval-fit.com.conf'`

sMessage="VHosts have been configured"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

sCheck=`sudo /opt/sevenval/fit14/bin/fitadmin config check -q`

sMessage="fitadmin config check"
if `$sCheck`; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

sMessage="fpmstatus.conf exists"
if [ -f "/opt/sevenval/fit14/conf/fpm.d/fpmstatus.conf" ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================


sMessage="PHP-FPM is running"
if sudo /opt/sevenval/fit14/sbin/phpfpmctl status 2>&1 > /dev/null; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================


sMessage="Apache is running"
if sudo /opt/sevenval/fit14/sbin/apachectl status 2>&1 > /dev/null; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi


# ====================================================================================================

sCheckBIN=`which fitadmin`
sCheckSBIN=`which phpfpmctl`

sMessage="PATH is valid"
if [ "$sCheckBIN" = "/opt/sevenval/fit14/bin/fitadmin" -a "$sCheckSBIN" = "/opt/sevenval/fit14/sbin/phpfpmctl" ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

sMessage="PATH is writen into '/etc/profile.d/fit14.sh'"
if grep -q "export PATH=/opt/sevenval/fit14/bin/:/opt/sevenval/fit14/sbin/:" "/etc/profile.d/fit14.sh"; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

iCheck=`curl -s 'http://192.168.56.14:8080/test.fit' | grep -c 'Overall: alive'`

sMessage="Config check (calling /test.fit per IP and HTTP)"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

EXP_VERSION=14.1.3
FIT_VERSION=`sudo /opt/sevenval/fit14/bin/fitadmin -v | head -n1`

sMessage="FIT Version '$EXP_VERSION' (is: $FIT_VERSION)"

if [ -z "${NO_VERSION_CHECK}" ]; then
	echo "$FIT_VERSION" | grep -q -P "Sevenval FIT Server ${EXP_VERSION}(-\d){0,2}, Build:" && \
		_printLine "$sMessage" 1 || _printLine "$sMessage" 0
else
	_printLine "  SKIPPED $sMessage" 1
fi

# ====================================================================================================

exit $failed
