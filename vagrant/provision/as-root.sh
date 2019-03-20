#!/usr/bin/env bash

timezone=$(echo "$1")
ip=$(echo "$2")
account_main=$(echo "$3")
account_empty_1=$(echo "$4")
account_empty_2=$(echo "$5")
account_sealer_1=$(echo "$6")
account_sealer_2=$(echo "$7")
account_alloc=$(echo "$8")
domain=$(echo "$9")

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
echo 'ACC_MAIN="${account_main}"' >> /etc/environment
echo 'ACC_01="${account_empty_1}"' >> /etc/environment
echo 'ACC_02="${account_empty_2}"' >> /etc/environment
echo 'SEAL_01="${account_sealer_1}"' >> /etc/environment
echo 'SEAL_02="${account_sealer_2}"' >> /etc/environment
echo 'ACC_ALLOC="${account_alloc}"' >> /etc/environment

info "Create subdomains under hosts file"
echo "${ip} faucet.${domain}" >> /etc/hosts
echo "${ip} wallet.${domain}" >> /etc/hosts
echo "${ip} stats.${domain}" >> /etc/hosts
echo "${ip} ${domain}" >> /etc/hosts
