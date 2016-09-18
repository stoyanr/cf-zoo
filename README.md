# Project
This project provides an easy way to try out [Cloud Foundry](https://github.com/cloudfoundry/cf-release) on your laptop or desktop. 

It installs Cloud Foundry and the [MySQL Broker](https://github.com/cloudfoundry/cf-mysql-broker) and aims to provide an easy way to try out other BOSH deployments as well.

# Prerequisites

You need:
* git
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)
* [CF CLI](https://github.com/cloudfoundry/cli#downloads)
* internet access without proxy

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

# Start using Cloud Foundry

0. Create and target a CF org and space:

  ```bash
  cf login -a api.bosh-lite.com --skip-ssl-validation -u admin -p admin
  cf create-org cf
  cf target -o cf
  cf create-space zoo
  cf target -s zoo
  ```

0. Push your application:

  ```bash
  cd <app-directory>
  cf push my-app
  ```
