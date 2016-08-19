#!/bin/bash

. $(dirname $(realpath -s $0))/base.sh

failfast=1

expect-priv "faucet to install without errors" <<'end'
  cd /faucet-src
  pip install .
end

expect "default config files to be placed in /etc/ryu/faucet" <<'end'
  test -f "/etc/ryu/faucet/faucet.yaml"
  test -f "/etc/ryu/faucet/gauge.conf"
end

set -e
echo "Copying over test configuration"
sudo mkdir -p /etc/ryu/faucet/
sudo cp /vagrant/data/faucet/faucet.yaml /etc/ryu/faucet/

echo "(Re)Creating log directories"
if test -d /var/log/ryu/faucet; then
  sudo rm -rf /var/log/ryu/faucet
fi
sudo mkdir -p /var/log/ryu/faucet/
set +e

expect-priv "installed faucet to load test configuration" <<'end'
  faucet_location=$(pip show ryu-faucet | grep ^Location: | awk -e '{print $2}')
  ryu-manager --verbose --ofp-tcp-listen-port=6634 \
    $faucet_location/ryu_faucet/org/onfsdn/faucet/faucet.py &
  faucet_pid=$!
  sleep 2
  # If ryu is still running after 2 seconds, then most likely faucet loaded
  kill $faucet_pid
end

expect-priv "source faucet to load test configuration" <<'end'
  ryu-manager --verbose --ofp-tcp-listen-port=6635 \
    /faucet-src/src/ryu_faucet/org/onfsdn/faucet/faucet.py &
  faucet_pid=$!
  sleep 2
  # If ryu is still running after 2 seconds, then most likely faucet loaded
  kill $faucet_pid
end

test_report
