# README

## Install vagrant-vbguest

First install vagrant-vbguest plugin. It's needed after kernel update, to keep virtualbox guest addition working.

For vagrant 1.1

    vagrant plugin install vagrant-vbguest

For Vagrant 1.0 and older	
	
	vagrant gem install vagrant-vbguest

Note : do not call this command inside the `test` dir, it will fails. 


## Launch vagrant

	git clone https://github.com/Filirom1/puppet-openshift_origin.git
	cd puppet-openshift_origin
	cd test
	vagrant up
	vagrant halt      # SELinux need a reboot
	vagrant up
	vagrant vbguest   # the kernel was updated, virtualbox guest-additions need to be updated too
	vagrant halt      # reboot the VM for shared folders to work
	vagrant up


## Setup OpenShift

    vagrant ssh
	rhc setup
	# Connect without checking the certificate? (yes|no): yes
    # Login to broker.example.com: admin
	# Password: admin
	# Generate a token now? (yes|no) yes
	# Your public SSH key must be uploaded to the OpenShift server to access code.  Upload now? (yes|no) yes
	# Please enter a namespace (letters and numbers only) |<none>|: ns
    # Your client tools are now configured.
	
## Use

Open your brower at <https://localhost/console>
Create an application
