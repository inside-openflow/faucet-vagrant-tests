#!/bin/bash
set -e

sudo apt-get -qy install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
cat <<EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo ubuntu-xenial main
EOF
sudo apt-get -qy update
sudo apt-get -qy purge lxc-docker || true
sudo apt-get -qy install linux-image-extra-$(uname -r) docker-engine
sudo service docker start
