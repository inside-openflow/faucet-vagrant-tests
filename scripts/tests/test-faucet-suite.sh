#!/bin/bash

. $(dirname $(realpath -s $0))/base.sh

failfast=1

expect "faucet to install globally" <<'end'
  sudo pip install /faucet-src
end

expect "faucet mininet tests to pass" <<'end'
  cd /faucet-dev/tests
  sudo ./faucet_mininet_test.py
end

expect "config tests to pass" <<'end'
  cd /faucet-dev/tests
  ./test_config.py
end
