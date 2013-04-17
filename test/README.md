# README

## Install

First install vagrant-vbguest plugin

    vagrant plugin install vagrant-vbguest

To install OpenShift in a Vagrant VM you should call

    vagrant up
    vagrant halt
    vagrant up
  
A restart is mandatory for SELinux

## Configure

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

Modify your /etc/hosts or your resolv.conf to point to the OpenShift DNS