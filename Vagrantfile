# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# 1.6.0 for run(always) provisioners
Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "sevenval-vagrant-centos-7.0-fit-x86_64"
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://download.sevenval-fit.com/vagrant/vagrant-fit14-centos-7.0-x86_64.box"
  
  # should you encounter problems with sahred folders or other things
  # which are handled by the Guestadditions, enable the following.
  # Otherwise it stays false to save time.
  config.vbguest.auto_update = false

  config.vm.network "private_network", ip: "192.168.56.14"
  config.vm.hostname = "local14.sevenval-fit.com"

  config.vm.synced_folder "projects", "/var/lib/fit14/projects", :mount_options => ["uid=1001,gid=1001"]
  config.vm.synced_folder "logs", "/var/log/fit14/", :mount_options => ["uid=1001,gid=1001"]

  config.vm.provision :shell, :path => "setup/bootstrap.sh"

  # Fit14 can't start via Init because the "projets" and "logs" volumes aren't
  # there. So we start it manually. At this point the volumes are mounted.
  # stop service before, if this is "vagrant provision" in a running box
  config.vm.provision :shell, :path => "setup/start-services.sh", run: "always"

  
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--memory", "512"]
	vb.customize [ "modifyvm", :id, "--ioapic", "on"]
	vb.customize [ "modifyvm", :id, "--cpus", "1" ]
	vb.customize [ "modifyvm", :id, "--cpuexecutioncap", "75" ]
	# workaround for NAT-DNS bug (5s resolving delay) 
	vb.customize [ "modifyvm", :id, "--natdnsproxy1", "off"]
	vb.customize [ "modifyvm", :id, "--natdnshostresolver1", "off"]
  end
end
