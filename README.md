# Inside OpenFlow's Faucet System Tests
Various tests using Vagrant to make sure Faucet and applications work properly
in multiple environments.

## Required Software
These tests require VirtualBox and Vagrant to be installed, along with make.

- Download and Install Vagrant from
  [VagrantUp.com](https://www.vagrantup.com/downloads.html).
- Download and Install VirtualBox from
  [VirtualBox.org](https://www.virtualbox.org/wiki/Downloads).

## Directory Layout
Clone this repository along-side faucet. For example:

    mkdir ~/faucet-workspace
    cd ~/faucet-workspace
    git clone https://github.com/onfsdn/faucet
    git clone https://github.com/inside-openflow/faucet-vagrant-tests

Vagrant will copy `../faucet` to `/faucet-src` on the VM.

## Alternate Use
Instead of using Vagrant to create the VMs and using the automated process,
simply run the provisioning scripts from `scripts/` in a fresh Ubuntu 16.04
64-bit install.
