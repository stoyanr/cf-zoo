Vagrant.configure('2') do |config|
  config.vm.box = 'hsiliev/cf-zoo'

  config.vm.provider :virtualbox do |v, override|
    v.memory = 8192
    override.vm.network :private_network, ip: '192.168.50.4', id: :local
  end

  config.vm.provision "shell", keep_color: true, path: "scripts/vm/bosh.sh"
  config.vm.provision "shell", keep_color: true, path: "scripts/vm/cf.sh"
  config.vm.provision "shell", keep_color: true, path: "scripts/vm/app.sh"
  config.vm.provision "shell", keep_color: true, path: "scripts/vm/cleanup.sh"
end
