Vagrant.configure('2') do |config|
  config.vm.box = 'cloudfoundry/bosh-lite'

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_version = '9000.137.0'
    v.memory = 8192
  end

  config.vm.provision "file", source: "scripts/setup/versions", destination: "versions"

  config.vm.provision "shell", keep_color: true, path: "scripts/setup/os-setup.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/stemcell.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/cf.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/diego.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/netman.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/deploy.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/mysql.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/setup/app.sh"
  config.vm.provision "shell", keep_color: true, path: "scripts/setup/cleanup.sh"
end
