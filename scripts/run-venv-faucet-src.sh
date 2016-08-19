#!/bin/bash
set -e

cd ~/faucet-dev
. venv/bin/activate
ryu-manager $@ ./faucet/src/ryu_faucet/org/onfsdn/faucet/faucet.py
