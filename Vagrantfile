Vagrant.configure('2') do |config|
  config.vm.box = 'cloudfoundry/bosh-lite'

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_version = '9000.131.0'
    v.memory = 6144
  end

  config.vm.provision "shell", keep_color: true, path: "os-setup.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "stemcell.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "cf.sh"
  config.vm.provision "shell", keep_color: true, privileged: false, path: "cleanup.sh"
end
