# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

%w{RAX_USERNAME RAX_API_KEY VAGRANT_ADMIN_PASSWORD}.each do |var|
  abort "Please set the environment variable #{var} in order to run the test" unless ENV.key? var
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "dummy"
  # disable NFS, make sure we use rsync or winrm
  config.nfs.functional = false

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "berks-cookbooks"]
    chef.add_recipe "crosstest"
  end

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.ssh.private_key_path = '~/.ssh/id_rsa'
    ubuntu.vm.provider :rackspace do |rs|
      rs.username = ENV['RAX_USERNAME']
      rs.admin_password = ENV['VAGRANT_ADMIN_PASSWORD']
      rs.api_key  = ENV['RAX_API_KEY']
      rs.flavor   = /1 GB Performance/
      rs.image    = '819355da-3940-41b3-96c3-326f67883307' # /Ubuntu/
      rs.rackspace_region   = ENV['RAX_REGION']
      rs.public_key_path = '~/.ssh/id_rsa.pub'
    end
  end

  if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.6.0')
    config.vm.define :windows do |windows|
      windows.vm.provision :shell, :inline => 'Write-Output "WinRM is working!"'

      windows.vm.guest = :windows
      windows.vm.allowed_synced_folder_types = :winrm
      windows.vm.communicator = :winrm
      windows.winrm.transport = :ssl
      windows.winrm.ssl_peer_verification = false
      windows.winrm.username = 'Administrator'
      windows.winrm.password = ENV['WINRM_PASS']
      # Disable synced folders, or set it to something that will work on Windows
      windows.vm.synced_folder ".", "/vagrant", disabled: true
      # windows.vm.synced_folder ".", "/vagrant", type: "winrm"

      windows.vm.provider :rackspace do |rs|
        rs.username = ENV['RAX_USERNAME']
        rs.api_key  = ENV['RAX_API_KEY']
        rs.rackspace_region   = ENV['RAX_REGION']
        rs.admin_password = ENV['WINRM_PASS']
        rs.flavor   = /2 GB General Purpose v1/
        rs.image    = 'Windows Server 2012'
        rs.init_script = File.read 'bootstrap.cmd'
      end

      begin
        windows.winrm.transport = :ssl
        windows.winrm.ssl_peer_verification = false
      rescue
        puts "Warning: Vagrant #{Vagrant::VERSION} does not support WinRM over SSL."
      end
    end
  end
end
