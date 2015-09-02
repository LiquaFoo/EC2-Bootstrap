## EC2 Bootstrap

EC2 Bootstrap is a custom Vagrant script used to stand up an entire development environment inside an Amazon VPC.

The tiers consist of Dev, QA, Staging (RC), Prod

In each tier the layers consist of the following layers segregated into individual subnets:

 - Nginx Load Balancer
 - NodeJS Web server
 - CouchDB caching server
 - MongoDB cluster

Additional Notes  
Nginx: Auto configured to point to the NodeJS webserver in its tier.  
MongoDB: Auto configured to be replicated and sharded. Uses a master, 2 slaves, and 1 arbiter.

Every server will attempt to assign it's self to and Active Directory server that you assign but that functionality can be removed by removing the networkconf states.

*You will need to fill out any fields formatted as {[example]} as this is info that is needed from your VPC or Domain/DNS Server. A simple find all {[ will help you discover this data.

*There is a deploy state that will allow for deploying code from the salt master to the NodeJS minions if you choose to use it. You can deploy from your CI server to the salt master and call the deploy state if you wish to limit the ports being exposed on the NodeJS web server.

*In shared/keys replace the ReadMe with the proper pem and pub keys you create that will be listed in the files. These keys are needed in order to perform various ssh tasking. 

## Salt
- The salt folder contains custom salt states used to provision the minions

### Salt Master Configuration
 - When implementing a new server be sure to install the Salt-Master package.
 - Once salt-master is installed you will want to copy the master conf file from the /srv/salt/conf folder and place it in /etc/salt/
 - Once the file has been copied restart the salt master service using the following command "sudo server salt-master restart"
 - For more information regarding the use of salt it is recomended you read the salt quick start guide. [Salt Walk-through](http://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html)

## Vagrant
- The vagrant folder contains a custom vagrant configuration used to create environment images in EC2

### Vagrant Configuration
 - Vagrant is used to spin up new instances of servers.
 - While creating the servers Vagrant will use the salt salt states in our salt /srv/salt/env/base/states to provision the server with the necessary packages.
 - The /srv/vagrant/shared folder contains files necessary for configuring servers. Do not delete things out of here unless you know what you are doing.
 - The main Vagrantfile resides in /srv/vagrant/shared/config
 - If modifications are needed to the Vagrantfile please be sure to make your changes to the master Vagrantfile in shared first, located in /srv/vagrant/shared/config" and copy that file to the choosen environment folder.
 - Each environment folder (dev, qa, rc, prod) in /srv/vagrant contains a copy of the Vagrantfile from /srv/vagrant/shared/config. The reason for having a folder per environment is so we can do a vagrant destroy on a specific tiers and not effect other tiers.
 - To start using vagrant change your working directory to the environment folder you wish to start working in. /srv/vagrant/{env}
     - To bring up a box use the command "scope={env} vagrant up {server name}"
     - To bring up all instances of know servers just call scope={env} vagrant up
     - To destroy a server use the command "vagrant destroy {server name}"
 - Vagrant uses plugins to provision new server instances on certain platforms in this case AWS & Salt. You can install new plugins using the command "vagrant plugin install {plugin name}"
     - [Salt-Vagrant](http://docs.vagrantup.com/v2/provisioning/salt.html)
     - [AWS-Vagrant](https://github.com/mitchellh/vagrant-aws)
 - For more info on vagrant see the quick start guide. [Vagrant Getting Started](http://docs.vagrantup.com/v2/getting-started/)
