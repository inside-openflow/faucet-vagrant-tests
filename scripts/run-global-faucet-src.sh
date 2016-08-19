#!/bin/bash
set -e

ryu-manager $@ /faucet-src/src/ryu_faucet/org/onfsdn/faucet/faucet.py
