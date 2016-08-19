#!/bin/bash
set -e

faucet_location=$(pip show ryu-faucet | grep ^Location: | awk -e '{print $2}')
ryu-manager $@ $faucet_location/ryu_faucet/org/onfsdn/faucet/faucet.py
