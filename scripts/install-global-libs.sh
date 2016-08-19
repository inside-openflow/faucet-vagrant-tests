#!/bin/bash
set -e

apt-get install -qy --no-install-recommends libyaml-dev libpython2.7-dev \
  python python-virtualenv

# NOTE: Ryu 4.5 dependencies REQUIRE pip 8.1.2, but only 8.1.1 is provided by
# Ubuntu 16.04. Pip therefore has to be installed manually when using a
# global Faucet install. Virtualenv automatically upgrades pip to 8.1.2 and
# does not have this issue.
apt-get purge -qy python-pip || true

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
