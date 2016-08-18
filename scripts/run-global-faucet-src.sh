#!/bin/bash
set -e

ryu-manager --ofp-tcp-listen-port=6633 \
  /faucet-src/src/ryu_faucet/org/onfsdn/faucet/faucet.py
