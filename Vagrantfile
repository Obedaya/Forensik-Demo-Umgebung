Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.define "ubuntu-server" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-20.04"
    ubuntu.vm.hostname = "ubuntu-server"
    ubuntu.vm.network "private_network", ip: "192.168.56.10"
    ubuntu.vm.provision "shell", inline: <<-SHELL
      # This kills the default route, blocking internet
      #sudo ip route del default || true
    SHELL
  end

  config.vm.define "kali-linux" do |kali|
    kali.vm.box = "kalilinux/rolling"
    kali.vm.hostname = "kali-linux"
    kali.vm.network "private_network", ip: "192.168.56.11"
  end

  config.vm.define "windows" do |win|
    win.vm.box = "gusztavvargadr/windows-10"
    win.vm.hostname = "windows"
    win.vm.network "private_network", ip: "192.168.56.12"
    win.vm.provision "shell", inline: <<-SHELL
      route delete 0.0.0.0 mask 0.0.0.0 10.0.2.2
      if ($LASTEXITCODE -ne 0) {
        exit 0
      }
    SHELL
  end
end
