# Project
This project provides an easy way to try out [Cloud Foundry](https://www.cloudfoundry.org/) on your laptop or desktop. 

It installs:
* [Cloud Foundry](https://github.com/cloudfoundry/cf-release)
* [Diego](https://github.com/cloudfoundry/diego-release)
* [Netman](https://github.com/cloudfoundry-incubator/cf-networking-release)
* [MySQL Broker](https://github.com/cloudfoundry/cf-mysql-broker) 

The project aims to provide an automated way to try out other BOSH deployments as well.

# Prerequisites

You need:
* git
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)
* [CF CLI](https://github.com/cloudfoundry/cli#downloads)

# Provision a VM

Clone the project and start the VM with:
```bash
git clone https://github.com/hsiliev/cf-zoo.git
cd cf-zoo
vagrant up
```

If the provisioning scripts fail you can resume them with:
```bash
vagrant provision
```

After VM or host computer restart you can fix the installation by running:
```bash
vagrant provision
```

# Start using Cloud Foundry

0. Login to CF

  ```bash
  ./scripts/login.sh
  ```
  
  On Windows:
  
  ```
  .\scripts\add-route.bat
  cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
  ```

0. Push your application:

  ```bash
  cd path/to/my-app
  cf push my-app
  ```
