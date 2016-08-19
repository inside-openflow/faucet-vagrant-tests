#!/bin/bash
set -e

cd /faucet-src
docker build -t reannz/faucet-tests -f Dockerfile.tests .
docker run --privileged -ti reannz/faucet-tests
