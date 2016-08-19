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

## Vagrant Machines
* `global-install` - VM for active development on Faucet (WIP)
* `mininet` - VM for running Mininet tests connected to other VMs
* `docker-test` - VM for running Faucet's Docker tests
* `global-install-test` - VM for running tests on Faucet installed globally
* `venv-install-test` - VM for running tests on Faucet installed in a Python
  virtual environment

## Alternate Use
Instead of using Vagrant to create the VMs and using the automated process,
simply run the provisioning scripts from `scripts/` in a fresh Ubuntu 16.04
64-bit install. See the `Vagrantfile` for which scripts to load.

## Testing
This environment contains the following test cases:

* Running the Faucet Docker tests (`make test-docker-test`)
  * Builds a new VM with docker installed
  * Builds Faucet's `Docker.tests`
  * Runs the test container as per Faucet documentation
* Running Faucet installed globally (`make test-global`)
  * Builds a new VM with all prereqs for Faucet to run with Ryu
  * Loads a test configuration for Faucet
  * Runs Mininet against the Faucet instance for a simple test to ensure
    connectivity
* Running Faucet installed in a Python Virtual Environment (`make test-venv`)
  * Builds a new VM with only the prereqs for `virtualenv` and Python
  * Creates a new virtual environment as a non-privileged user
  * Loads test configuration for Faucet in the virtual environment
  * Runs Mininet against the Faucet instance for a simple test to ensure
    connectivity

Faucet's full test suites (run in the docker container above) will be added
to the non-docker targets eventually (see onfsdn/faucet#10)

### Other Targets
* `make test` - Runs all tests. The first run may take a while since it has
  to provision VMs. Subsequent tests should be much faster unless the
  `full-test` target is run
* `make full-test` - Destroys any previous test VMs and reprovisions them,
  ensuring a fresh install of all requirements, then runs `test` and `halt`
* `make halt` - Same as `vagrant halt`

See `Makefile` for more targets.
