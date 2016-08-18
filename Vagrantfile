# -*- mode: ruby -*-
# vi: set ft=ruby :

# Linked Clones require 1.8 or above
Vagrant.require_version ">=1.8"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  # Remove "rsync" type after cloud-images LP#1565985 is resolved.
  config.vm.synced_folder "../faucet", "/faucet-src", type: "rsync",
    rsync__exclude: ".git/"
  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "2048"

    # Use linked clones to make privisioning faster, since these VMs
    # are designed to be destroyed and recreated several times and the
    # base image is the same for all VMs.
    # vb.linked_clones = true
  end
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", path: "scripts/init-box.sh"

  # Define the individual VMs
  config.vm.define "docker-test", autostart: false do |dt|
    # Ubuntu's official 16.04 box is currently borked (2016/08/18), but
    # hopefully this can be removed on the next release of the box. See
    # https://bugs.launchpad.net/cloud-images/+bug/1565985
    dt.vm.provider "virtualbox" do |vb|
      vb.name = "fvt-docker-test"
    end

    dt.vm.provision "shell", path: "scripts/install-docker.sh"
    dt.vm.provision "shell", path: "scripts/build-docker-test.sh"

    # Run the docker test with:
    # vagrant ssh docker-test -c "/vagrant/scripts/run-docker-test.sh"
  end

  config.vm.define "global-install", autostart: false do |gi|
    # Ubuntu's official 16.04 box is currently borked (2016/08/18), but
    # hopefully this can be removed on the next release of the box. See
    # https://bugs.launchpad.net/cloud-images/+bug/1565985
    gi.vm.provider "virtualbox" do |vb|
      vb.name = "fvt-global-install"
    end

    gi.vm.network "forwarded_port", guest: 6633, host: 6633

    gi.vm.synced_folder "data/etc/ryu/faucet", "/etc/ryu/faucet", type: "rsync"
    gi.vm.synced_folder "data/var/log/ryu/faucet", "/var/log/ryu/faucet",
      type: "rsync"

    gi.vm.provision "shell", path: "scripts/install-global-libs.sh"
    #gi.vm.provision "shell", path: "scripts/faucet-global-install.sh"

    # Run faucet from installed library:
    # vagrant ssh global-install -c "/vagrant/scripts/run-global-faucet.sh"

    # Run faucet from source:
    # vagrant ssh global-install -c "/vagrant/scripts/run-global-faucet-src.sh"
  end
end