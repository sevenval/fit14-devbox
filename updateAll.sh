#!/bin/bash
# Destroys the vagrant environment and updates the devbox to the latest stable version.

cat <<'EOF'
Starting SDK update

CAUTION: local changes inside the VM will be lost!
Data on your host system, e.g. projects/, will remain untouched

EOF

set -e

vagrant destroy

git pull --ff-only

vagrant up

cat <<'EOF'

Checking setup
(this may take some time)

EOF
./setup/check_external.sh
