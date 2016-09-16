# cf-lite
Developer’s version of CF &amp; MySQL Broker

This repo provides an easy way to try out [Cloud Foundry](https://github.com/cloudfoundry/cf-release) on your laptop or desktop by installing the runtime and the [MySQL Broker](https://github.com/cloudfoundry/cf-mysql-broker).

# Prerequisites

You need:
* git
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)
* internet access without proxy 

# Start the VM

Clone the project and start the VM with

```
git clone https://github.com/hsiliev/cf-dev.git
cd cf-dev
vagrant up
```

If the provisioning scripts fail you can resume them with:
```
vagrant provision
```
