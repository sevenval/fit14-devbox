# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# 1.6.0 for run(always) provisioners
Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "vagrant-fit14-devbox-14.0.0-1"
  config.vm.box_url = "https://download.sevenval-fit.com/fit-devbox/14/images/vagrant-fit14-devbox-14.0.0-1.box"
  config.vm.box_download_checksum = "5db09ccb8a5a6bc6e751281ec9c2dd4decac161a"
  config.vm.box_download_checksum_type = "sha1"

  config.vm.network "private_network", ip: "192.168.56.14"
  config.vm.hostname = "local14.sevenval-fit.com"

  config.vm.synced_folder "projects", "/var/lib/fit14/projects", :mount_options => ["uid=1001,gid=1001"]
  config.vm.synced_folder "logs", "/var/log/fit14/", :mount_options => ["uid=1001,gid=1001"]

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
