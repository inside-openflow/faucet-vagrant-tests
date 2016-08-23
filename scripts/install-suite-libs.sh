#!/bin/bash
set -e

apt-get install -qy --no-install-recommends vlan psmisc git sudo net-tools \
  iputils-ping netcat-openbsd tcpdump

# Although Mininet 2.2.1 doesnt work properly on Xenial, it is specified for
# the Faucet tests, so we use it here.
mkdir ~/mininet
cd ~/mininet
git clone git://github.com/mininet/mininet
cd mininet
git checkout -b 2.2.1 2.2.1
cd ..
mininet/util/install.sh -nfv

wget --no-check-certificate \
  https://github.com/Exa-Networks/exabgp/archive/3.4.10.tar.gz
tar -zxf 3.4.10.tar.gz
cd exabgp-3.4.10
python setup.py install
