#!/bin/bash

if [ -n "$1" ]; then
	VERSION=$1
else
	read -p '(n)ightly (d)evel (s)table? ' VERSION
	case "$VERSION" in
	"n") VERSION=fit14nightly ;;
	"d") VERSION=fit14devel ;;
	"s") VERSION=fit14stable ;;
	*) echo "n/d/s" >&2; exit 1;;
	esac
fi

case "$VERSION" in
"fit14nightly");;
"fit14devel");;
"fit14stable");;
*) echo "version must be fit14stable, fit14devel or fit14nightly" >&2; exit 1;;
esac

if [ -f /vagrant/setup/switch-version-internal.sh ]; then
	sudo bash /vagrant/setup/switch-version-internal.sh $VERSION
else
	vagrant ssh -c "sudo bash /vagrant/setup/switch-version-internal.sh $VERSION" -- -q
fi

