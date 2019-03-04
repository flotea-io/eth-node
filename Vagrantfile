require 'yaml'

required_plugins = %w( vagrant-hostmanager vagrant-vbguest )
required_plugins.each do |plugin|
    system("vagrant plugin install #{plugin}", :chdir=>"/tmp") || exit! unless Vagrant.has_plugin?(plugin)
end

domains = {
  app: 'eth.devel'
}

vagrantfile_dir_path = File.dirname(__FILE__)

config = {
  local: vagrantfile_dir_path + '/vagrant/config/vagrant-local.yml'
}

options = YAML.load_file config[:local]

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.box_check_update = options['box_check_update']

  config.vm.provider 'virtualbox' do |vb|
    vb.cpus = options['cpus']
    vb.memory = options['memory']
    vb.name = options['machine_name']
  end

  config.vm.define options['machine_name']
  config.vm.hostname = options['machine_name']
  config.vm.network 'private_network', ip: options['ip']
  config.vm.synced_folder './', '/app', owner: 'vagrant', group: 'vagrant'
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provision :hostmanager
  config.hostmanager.enabled            = true
  config.hostmanager.manage_host        = true
  config.hostmanager.ignore_private_ip  = false
  config.hostmanager.include_offline    = true
  config.hostmanager.aliases            = domains.values

  config.vm.provision 'shell', path: './vagrant/provision/once-as-root.sh', args: [options['timezone']]
  config.vm.provision 'shell', path: './vagrant/provision/once-as-vagrant.sh', args: [], privileged: false
  config.vm.provision 'shell', path: './vagrant/provision/always-as-root.sh', run: 'always'

end
