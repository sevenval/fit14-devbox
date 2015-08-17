#! /bin/bash -e

# ====================================================================================================

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -i failed

source functions.sh

# ====================================================================================================

vagrant ssh -c 'sudo su -c "source /etc/profile.d/fit14.sh; bash /vagrant/setup/check_internal.sh"' 2>&1 | grep -v 'Connection to 127.0.0.1 closed.'
failed=${PIPESTATUS[0]}

# ====================================================================================================

iCheck=`tail ../logs/access_log | grep local14.sevenval-fit.com -c`
sMessage="FIT logs accessible on host"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

iCheck=`curl -m 3 -k -s 'http://local14.sevenval-fit.com/' | grep -c 'Welcome'`
sMessage="Domain check (local14.sevenval-fit.com:80)"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================
iCheck=`curl -m 3 -k -s 'https://local14.sevenval-fit.com/' | grep -c 'Welcome'`
sMessage="Domain check (local14.sevenval-fit.com:443)"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================
sMessage="Domain check (*.local14.sevenval-fit.com:443 _default)"
iCheck=`curl -m 3 -k -s 'https://anything-falls-back-to-default.local14.sevenval-fit.com/' | grep -c 'Project: _default Site: _default'`
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================
sMessage="Domain check (*.local14.sevenval-fit.com:80)"

if [ ! -d ../projects/_default/sites/checkexttestsite ]; then (cd ../projects/_default/sites/ && ln -s _default checkexttestsite); fi
if [ ! -d ../projects/checkexttestproject ]; then (cd ../projects/ && ln -s _default checkexttestproject); fi

iCheck=`curl -L -m 3 -k -s 'http://checkexttestproject.local14.sevenval-fit.com/checkexttestsite' | grep -c 'Project: checkexttestproject Site: checkexttestsite'`
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================
sMessage="Domain check (*.local14.sevenval-fit.com:443)"
iCheck=`curl -L -m 3 -k -s 'https://checkexttestproject.local14.sevenval-fit.com/checkexttestsite' | grep -c 'Project: checkexttestproject Site: checkexttestsite'`
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================
sMessage="Domain check (*.*.local14.sevenval-fit.com:443)"
iCheck=`curl -m 3 -k -s 'https://checkexttestsite.checkexttestproject.local14.sevenval-fit.com/' | grep -c 'Project: checkexttestproject Site: checkexttestsite'`
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

rm -f  ../projects/_default/sites/checkexttestsite
rm -f ../projects/checkexttestproject


# ====================================================================================================
sMessage="Domain check 404 (*.*.local14.sevenval-fit.com:443)"
if curl -m 3 -k -s -f 'https://not.there.local14.sevenval-fit.com/' > /dev/null; then
	_printLine "$sMessage" 0
else
	_printLine "$sMessage" 1
fi

# ====================================================================================================

iCheck=`curl -m 3 -k -s 'http://local14.sevenval-fit.com:8080/test.fit' | grep -c 'Overall: alive'`

sMessage="Config check (calling /test.fit per hostname and HTTP)"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

declare -i iAccessLogBeforeLines=`wc -l ../logs/access_log | awk '{print $1}'`
declare -i iFPMLogBeforeLines=`wc -l ../logs/phpfpm_access_log | awk '{print $1}'`

iCheck=`curl -m 3 -k -s 'https://local14.sevenval-fit.com:8443/test.fit' | grep -c 'Overall: alive'`

sleep 1
declare -i iAccessLogAfterLines=`wc -l ../logs/access_log | awk '{print $1}'`
declare -i iFPMLogAfterLines=`wc -l ../logs/phpfpm_access_log | awk '{print $1}'`

sMessage="Config check (calling /test.fit per hostname and HTTPS)"
if [ "$iCheck" -gt 0 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

sMessage="access_log grows"
if [ $[ $iAccessLogAfterLines - $iAccessLogBeforeLines ] -eq 1 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

sMessage="phpfpm_access_log grows"
if [ $[ $iFPMLogAfterLines - $iFPMLogBeforeLines ] -eq 1 ]; then
	_printLine "$sMessage" 1
else
	_printLine "$sMessage" 0
fi

# ====================================================================================================

declare -i status=1

echo

case $failed in
	0)
		echo "Success."
		status=0
		;;
	1)
		echo "FAILED: 1 check failed."
		;;
	*)
		echo "FAILED: $failed checks failed."
		;;
esac

exit $status
