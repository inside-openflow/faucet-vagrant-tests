#!/bin/bash
set -e

# Virtualenv will automatically upgrade pip inside the virtual environment, so
# we can use the system packages here, unlike the global install
apt-get install -qy --no-install-recommends python python-virtualenv \
  virtualenv python-pip
