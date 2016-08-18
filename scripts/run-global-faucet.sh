#!/bin/bash
set -e

ryu-manager --ofp-tcp-listen-port=6633 faucet
