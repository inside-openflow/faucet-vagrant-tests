.PHONY: all
all:
	echo "Targets: destroy test test-global test-venv run-global run-docker-test"
	echo "         full-test"

.PHONY: destroy destroy-test destroy-docker-test destroy-venv destroy-global halt
destroy:
	vagrant destroy -f

destroy-test: destroy-docker-test destroy-venv destroy-global

destroy-docker-test:
	vagrant destroy docker-test -f

destroy-venv:
	vagrant destroy venv-install-test -f

destroy-global:
	vagrant destroy global-install-test -f

halt:
	vagrant halt

.PHONY: test test-global test-venv test-docker-test full-test
test:
	$(MAKE) test-docker-test
	$(MAKE) test-global
	$(MAKE) test-venv
	$(MAKE) halt-tests

test-docker-test: halt-tests
	vagrant up docker-test
	vagrant ssh docker-test -c "sudo /vagrant/scripts/build-docker-test.sh"
	vagrant ssh docker-test -c "sudo /vagrant/scripts/run-docker-test.sh"

test-global: halt-tests
	$(MAKE) up-mininet
	$(MAKE) up-global-install-test
	vagrant ssh global-install-test \
		-c "/vagrant/scripts/tests/test-faucet-global-install.sh"
	vagrant ssh global-install-test \
	  -c "sudo /vagrant/scripts/run-global-faucet-src.sh" &
	vagrant ssh mininet \
		-c "sudo mn --test pingpair --mac --controller remote,192.168.50.20:6633"
	vagrant ssh global-install-test \
		-c "sudo pkill ryu-manager"

test-venv: halt-tests
	$(MAKE) up-mininet
	$(MAKE) up-venv-install-test
	vagrant ssh venv-install-test \
		-c "/vagrant/scripts/tests/test-faucet-venv-install.sh"
	vagrant ssh venv-install-test \
	  -c "/vagrant/scripts/run-venv-faucet-src.sh" &
	vagrant ssh mininet \
		-c "sudo mn --test pingpair --mac --controller remote,192.168.50.21:6633"
	vagrant ssh venv-install-test \
		-c "sudo pkill ryu-manager"

full-test:
	$(MAKE) destroy-test
	$(MAKE) test
	$(MAKE) halt

.PHONY: up-global-install-test up-mininet up-venv-install-test halt-tests
up-mininet:
	vagrant up mininet
	$(MAKE) clean-mininet

up-venv-install-test:
	vagrant up venv-install-test

up-global-install-test:
	vagrant up global-install-test

halt-tests:
	vagrant halt '/-test$$/'

.PHONY: clean-mininet
clean-mininet:
	vagrant ssh mininet -c "sudo mn -c" || true
