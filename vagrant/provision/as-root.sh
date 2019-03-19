#!/usr/bin/env bash

timezone=$(echo "$1")

function info {
  echo " "
  echo "-> $1"
  echo " "
}

#== Provision script ==
info "Provision-script user: `whoami`"
info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Update OS software"
apt-get update
apt-get upgrade -y

info "Install additional software"
apt-get install -y git curl bison build-essential g++ docker.io docker-compose expect

info "Install Geth"
apt-get install -y software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install -y ethereum
echo "Done!"

info "Install NODE & NPM"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt-get install -y nodejs

info "Install go lang"
sudo snap install go --classic

#info "Init ethnode, sealers service"
#systemctl enable /app/vagrant/config/ethnode.service
#systemctl enable /app/vagrant/config/sealer01.service
#systemctl enable /app/vagrant/config/sealer02.service
#echo "Done!"

info "Usermod Docker"
usermod -aG docker vagrant
echo "Done!"

info "Configure public key"
su -c 'ssh-keygen -f ~/.ssh/id_rsa -q -N ""' -s /bin/sh vagrant
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
service sshd restart

# Accoutnts Are pregenerated, define as env variable
info "Create environment variables from wallets"
echo 'ACC_MAIN="0xb2ba413fba6361bacc7a2055c2b28d6c93cf138e"' >> /etc/environment
echo 'ACC_01="0xac5a29b299e6fc030abe9a23b16f05123136922c"' >> /etc/environment
echo 'ACC_02="0xc17cdea27b2a4ff2ec0d52b2b61d41ebd55bad2b"' >> /etc/environment
echo 'SEAL_01="0x59e3dfd51852cf0a0710b50982ce0de91576abf6"' >> /etc/environment
echo 'SEAL_02="0x390c1c74d1d5ab47a876eab170ab98b5bb864165"' >> /etc/environment
echo 'ACC_ALLOC="0x3e216b18e24c6cbe4c68e68b8c7bfebd664526c4"' >> /etc/environment

info "Create subdomains under hosts file"
echo "192.168.66.66 faucet.eth.devel" >> /etc/hosts
echo "192.168.66.66 wallet.eth.devel" >> /etc/hosts
echo "192.168.66.66 stats.eth.devel" >> /etc/hosts
echo "192.168.66.66 eth.devel" >> /etc/hosts
