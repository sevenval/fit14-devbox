
CMD="sudo /opt/sevenval/fit14/bin/fitadmin -v | grep -v opyright; CH=\$(yum --noplugins --quiet repolist enabled |grep fit14 | cut -d/ -f1 | sed 's/^!*\(\S\+\).*$/\1/'); echo \"Channel: \${CH:-[stable]}\";   "
if [ -f /vagrant/setup/switch-version-internal.sh ]; then
	sh -c "$CMD"
else
	vagrant ssh -c "$CMD" -- -q
fi

