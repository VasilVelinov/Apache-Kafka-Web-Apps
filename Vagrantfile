# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "containers" do |containers|
    containers.vm.box = "shekeriev/centos-stream-9"
    containers.vm.hostname = "containers.do2.lab"
    containers.vm.network "private_network", ip: "192.168.56.100"
    containers.vm.provision "shell", path: "bash_scripts/setup_salt_minion.sh"
    containers.vm.provision "shell", path: "bash_scripts/setup_salt_master.sh"
  end

  config.vm.define "db" do |db|
    db.vm.box = "shekeriev/centos-stream-9"
    db.vm.hostname = "db.do2.lab"
    db.vm.network "private_network", ip: "192.168.56.102"
  end
  
  config.vm.define "web" do |web|
    web.vm.box = "shekeriev/debian-11"
    web.vm.hostname = "web.do2.lab"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.provision "shell", path: "bash_scripts/setup_ansible.sh"
  end
end
