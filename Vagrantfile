Vagrant.configure('2') do |config|
  config.vm.box = 'cloudfoundry/bosh-lite'

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_version = '9000.137.0'
    v.memory = 6144
  end

  config.vm.provision "file", source: "scripts/vm/versions", destination: "versions"

  config.vm.provision "shell", keep_color: true, path: "scripts/vm/os-setup.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/stemcell.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/cf.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/diego.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/netman.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/deploy.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/mysql.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "scripts/vm/cleanup.sh"
end
