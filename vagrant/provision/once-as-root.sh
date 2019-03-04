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
apt-get install -y nginx

info "Install Geth"
apt-get install -y software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install -y ethereum
echo "Done!"

info "Configure NGINX"
sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
echo "Done!"

info "Enabling site configuration"
ln -s /app/vagrant/config/nginx/app.conf /etc/nginx/sites-enabled/app.conf
echo "Done!"

info "Removing default site configuration"
rm /etc/nginx/sites-enabled/default
echo "Done!"

info "Init ethnode service"
systemctl enable /app/vagrant/config/ethnode.service
echo "Done!"
