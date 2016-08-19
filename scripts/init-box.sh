#!/bin/bash
set -e # Fail on error

# Fix /etc/hosts
cat <<'eof' > /etc/hosts
127.0.0.1       localhost
127.0.1.1       ubuntu-xenial

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
eof

apt-get -qy update

# Workaround for https://bugs.launchpad.net/cloud-images/+bug/1565985
# If VirtualBox shared folders is required, uncomment below and do a
# manual `vagrant provision` after a failed `vagrant up` on the first run
# apt-get -qy install --no-install-recommends virtualbox-guest-utils
