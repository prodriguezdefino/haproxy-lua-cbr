VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  
  config.vm.provider :virtualbox do |vb|
    #memory
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  config.vm.hostname = "haproxy-cbr-devenv-host.dev"
  config.vm.box = "ubuntu/trusty64"

  # haproxy ports
  config.vm.network "forwarded_port", guest: 8080, host:8080  

  # node ports
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3001, host: 3001


  config.vm.provision :shell, inline: <<-SCRIPT
    sudo apt-get update
    sudo apt-get upgrade
    # Set correct source list
    echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
    echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe" >> /etc/apt/sources.list

    # add the python properties so we can add repos afterwards and also the utility to auto-accept licens es, some dev tools too
    apt-get update && apt-get upgrade -y && apt-get install -y net-tools vim-tiny sudo iputils-ping less curl
  SCRIPT

  config.vm.provision "docker",
    images: ["janeczku/alpine-haproxy:1.6.3-lua", "crosbymichael/skydock", "crosbymichael/skydns", "library/node"]

  # startup devenv containers 
  config.vm.provision :shell, run: "always", path: "internal/devenv-startup.sh"
  
end
