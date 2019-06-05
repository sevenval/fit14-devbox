# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# 1.6.0 for run(always) provisioners
# 1.6.5 to fix centos7 networking
Vagrant.require_version ">= 1.6.5"

# 1.8.5 broken: https://github.com/mitchellh/vagrant/issues/7610
Vagrant.require_version "!= 1.8.5"

# read credentials
begin
	download_creds = File.read('./credentials').chomp!
	if !download_creds.empty?
		download_creds << "@"
	end
rescue
	download_creds = ""
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
config.vm.box = "vagrant-fit14-devbox-14.6.16-0"
config.vm.box_url = "https://#{download_creds}download.sevenval-fit.com/fit-devbox/14/images/vagrant-fit14-devbox-14.6.16-0.box"
config.vm.box_download_checksum = "1bf0000bdb84c77f976e87c57fa0abf142d2b753"
config.vm.box_download_checksum_type = "sha1"

  # disable plugin because image contains no build tools and kernel headers
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.network "private_network", ip: "192.168.56.14"
  config.vm.hostname = "local14.sevenval-fit.com"

  config.vm.synced_folder "projects", "/var/lib/fit14/projects", :mount_options => ["uid=1000,gid=1000"]
  config.vm.synced_folder "logs", "/var/log/fit14/", :mount_options => ["uid=1000,gid=1000"]

  config.vm.provision :shell, :path => "setup/start-services.sh", run: "always"

  config.vm.provider "virtualbox" do |vb|
	# adapt to your needs and hardware
	#vb.customize [ "modifyvm", :id, "--ioapic", "on"]
    #vb.customize [ "modifyvm", :id, "--memory", "512"]
	#vb.customize [ "modifyvm", :id, "--cpus", "1" ]
	#vb.customize [ "modifyvm", :id, "--cpuexecutioncap", "75" ]
  end
end
