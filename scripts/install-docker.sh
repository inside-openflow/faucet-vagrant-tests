#!/bin/bash
set -e

apt-get -qy install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
cat >/etc/apt/sources.list.d/docker.list <<EOF
deb https://apt.dockerproject.org/repo ubuntu-xenial main
EOF
apt-get -qy update
apt-get -qy purge lxc-docker || true
apt-get -qy install linux-image-extra-$(uname -r) docker-engine
service docker start
