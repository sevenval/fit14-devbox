# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# 1.6.0 for run(always) provisioners
# 1.6.5 to fix centos7 networking
Vagrant.require_version ">= 1.6.5"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "vagrant-fit14-devbox-14.0.1-0"
  config.vm.box_url = "https://download.sevenval-fit.com/fit-devbox/14/images/vagrant-fit14-devbox-14.0.1-0.box"
  config.vm.box_download_checksum = "c74c7c84650cf3193aa209aa61e94b16d187e682"
  config.vm.box_download_checksum_type = "sha1"

  config.vm.network "private_network", ip: "192.168.56.14"
  config.vm.hostname = "local14.sevenval-fit.com"

  config.vm.synced_folder "projects", "/var/lib/fit14/projects", :mount_options => ["uid=1001,gid=1001"]
  config.vm.synced_folder "logs", "/var/log/fit14/", :mount_options => ["uid=1001,gid=1001"]

  config.vm.provision :shell, :path => "setup/start-services.sh", run: "always"

  config.vm.provider "virtualbox" do |vb|
	# adapt to your needs and hardware
	#vb.customize [ "modifyvm", :id, "--ioapic", "on"]
    #vb.customize [ "modifyvm", :id, "--memory", "512"]
	#vb.customize [ "modifyvm", :id, "--cpus", "1" ]
	#vb.customize [ "modifyvm", :id, "--cpuexecutioncap", "75" ]
  end
end
