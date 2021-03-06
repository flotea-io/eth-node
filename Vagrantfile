require 'yaml'

#https://github.com/devopsgroup-io/vagrant-digitalocean

required_plugins = %w( vagrant-hostmanager vagrant-vbguest )
required_plugins.each do |plugin|
    system("vagrant plugin install #{plugin}", :chdir=>"/tmp") || exit! unless Vagrant.has_plugin?(plugin)
end

vagrantfile_dir_path = File.dirname(__FILE__)

config = {
  local: vagrantfile_dir_path + '/vagrant/config/vagrant-local.yml'
}

options = YAML.load_file config[:local]


domains = {
  app: options['domain']
}

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

  args = [
    options['timezone'],
    options['ip'],
    options['accounts']['account_main'],
    options['accounts']['account_empty_1'],
    options['accounts']['account_empty_2'],
    options['accounts']['account_sealer_1'],
    options['accounts']['account_sealer_2'],
    options['accounts']['account_alloc'],
    options['domain'],
    options['network_name'],
    options['genesis_file'],
    options['secret_api_password'],
    options['location']
  ]

  config.vm.provision 'shell', path: './vagrant/provision/as-root.sh', args: args
  config.vm.provision 'shell', path: './vagrant/provision/as-vagrant.sh', privileged: false
  config.vm.provision 'shell', path: './vagrant/provision/configure-network.sh', args: args, privileged: false
  config.vm.provision 'shell', path: './vagrant/provision/always-as-root.sh', run: 'always'

end
