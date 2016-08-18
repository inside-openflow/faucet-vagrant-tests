#!/bin/bash
set -e # Fail on error

sudo apt-get -qy update

# Workaround for https://bugs.launchpad.net/cloud-images/+bug/1565985
# If VirtualBox shared folders is required, uncomment below and do a
# manual `vagrant provision` after a failed `vagrant up` on the first run
# sudo apt-get -qy install --no-install-recommends virtualbox-guest-utils
