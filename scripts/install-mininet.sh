#!/bin/bash
set -e

apt-get install -qy --no-install-recommends vlan psmisc git net-tools \
  iputils-ping netcat-openbsd tcpdump python libpython2.7-dev

mkdir -p ~/mnworkspace
cd ~/mnworkspace
if [[ ! -e mininet ]]; then
  # This may be a reprovisioning, so only clone once
  git clone git://github.com/mininet/mininet

  # NOTE: Mininet 2.2.1 doesn't work in Ubuntu 15.10+, so we use master here
  # see: https://github.com/mininet/mininet/issues/601
  #cd mininet
  #git checkout -b 2.2.1 2.2.1
  #cd ..
  mininet/util/install.sh -nfv
fi

# Run regression test to ensure mininet is installed properly
mn --test pingpair
