#!/bin/bash

if [ -n "$1" ]; then
	VERSION=$1
else
	read -p '(c)andidate (b)eta (s)table? ' VERSION
	case "$VERSION" in
	"c") VERSION=candidate ;;
	"b") VERSION=beta ;;
	"s") VERSION=stable ;;
	*) echo "b/s" >&2; exit 1;;
	esac
fi

# sanitize input
VERSION=${VERSION#fit14}
VERSION=${VERSION//[^a-zA-Z0-9.-]/_}

if [ -f /vagrant/setup/switch-version-internal.sh ]; then
	sudo bash /vagrant/setup/switch-version-internal.sh $VERSION
else
	vagrant ssh -c "sudo bash /vagrant/setup/switch-version-internal.sh $VERSION" -- -q
fi

