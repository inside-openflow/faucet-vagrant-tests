#!/bin/bash

. $(dirname $(realpath -s $0))/base.sh

failfast=1

# Clear existing environment
set -e
echo "Clearing existing environment if exists"
if test -e ~/faucet-dev; then
  rm -rf ~/faucet-dev
fi
set +e

expect "ability to set up dev environment for non-privileged user" <<'end'
  mkdir -p ~/faucet-dev
  cp -r /faucet-src ~/faucet-dev/faucet
end

expect "virtualenv to create the virtual environment" <<'end'
  virtualenv ~/faucet-dev/venv
end

expect "faucet to install without errors in the virtual environment" <<'end'
  cd ~/faucet-dev
  . venv/bin/activate
  pip install ./faucet
end

expect "faucet default configs to be in venv" <<'end'
  test -f ~/faucet-dev/venv/etc/ryu/faucet/faucet.yaml
  test -f ~/faucet-dev/venv/etc/ryu/faucet/gauge.conf
end

expect "ryu-manager to be available in the venv after faucet install" <<'end'
  cd ~/faucet-dev
  . venv/bin/activate
  venv/bin/ryu-manager --version
  test $(which ryu-manager) = $(realpath -s ./venv/bin/ryu-manager)
end

set -e
echo "Copying over test configuration"
mkdir -p ~/faucet-dev/venv/etc/ryu/faucet
cp /vagrant/data/faucet/faucet.yaml ~/faucet-dev/venv/etc/ryu/faucet/

echo "(Re)Creating log directories"
if test -d ~/faucet-dev/venv/var/log/ryu/faucet; then
  rm -rf ~/faucet-dev/venv/var/log/ryu/faucet
fi
mkdir -p ~/faucet-dev/venv/var/log/ryu/faucet/
set +e

expect "installed faucet to load test configuration" <<'end'
  cd ~/faucet-dev
  . venv/bin/activate
  faucet_location=$(pip show ryu-faucet | grep ^Location: | awk -e '{print $2}')
  ryu-manager --verbose --ofp-tcp-listen-port=6634 \
    $faucet_location/ryu_faucet/org/onfsdn/faucet/faucet.py &
  faucet_pid=$!
  sleep 2
  # If ryu is still running after 2 seconds, then most likely faucet loaded
  kill $faucet_pid
end

expect "source faucet to load test configuration" <<'end'
  cd ~/faucet-dev
  . venv/bin/activate
  ryu-manager --verbose --ofp-tcp-listen-port=6635 \
    ~/faucet-dev/faucet/src/ryu_faucet/org/onfsdn/faucet/faucet.py &
  faucet_pid=$!
  sleep 2
  # If ryu is still running after 2 seconds, then most likely faucet loaded
  kill $faucet_pid
end

test_report
