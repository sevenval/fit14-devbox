#!/bin/bash

if [ -n "$1" ]; then
	VERSION=$1
else
	read -p '(n)ightly (d)evel (s)table? ' VERSION
	case "$VERSION" in
	"n") VERSION=fit14nightly ;;
	"d") VERSION=fit14devel ;;
	"s") VERSION=fit14stable ;;
	*) echo "n/d/s"; exit 1;;
	esac
fi

if [ -f /vagrant/setup/switch-version-internal.sh ]; then
	sudo bash /vagrant/setup/switch-version-internal.sh $VERSION
else
	vagrant ssh -c "sudo bash /vagrant/setup/switch-version-internal.sh $VERSION"
fi

