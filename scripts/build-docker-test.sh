#!/bin/bash
set -e

cd /faucet-src
docker build -t reannz/faucet-tests -f Dockerfile.tests .
apparmor_parser -R /etc/apparmor.d/usr.sbin.tcpdump
modprobe openvswitch
