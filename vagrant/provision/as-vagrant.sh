#!/usr/bin/env bash

info "Provision-script user: `whoami`"

info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc


info "Init Blockchain datadirs .ethereum .ethereum2 on flotea.json genesis"
geth --cache 512 --datadir .ethereum/ init /app/vagrant/config/genesis/flotea.json
geth --cache 512 --datadir .ethereum2/ init /app/vagrant/config/genesis/flotea.json
info "Copying keystore from pregenerated accounts"
cp /app/vagrant/config/accounts/sealer--59* .ethereum/keystore/signer.json
cp /app/vagrant/config/accounts/sealer--39* .ethereum2/keystore/signer.json
touch signer.pass
echo "testpasswd" > signer.pass
echo "Done!"

info "Configure Global NPM directory"
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile

# NodeKey
#/home/vagrant/bootnode/geth/nodekey e1d8605a3f7aed335ae093320542467f61a2dd1741d4b31c575306021afb0742
#admin.nodeInfo.enode

#Sealers
#@todo
#geth --networkid 777 --cache 512 --port 30502 --nat extip:192.168.66.66 --maxpeers 50  --ethstats 'sealer01:test7@stats.eth.devel' --bootnodes enode://818264acf4097e89dd7d7c3ea5fd7844a9f49389567b1ae22820464477f7897a9fb7932f690a973cde64b3815e4ed5bb0b4fe1476d67b6aae4dd616c4aef14ee@192.168.66.66:30303  --unlock 0 --password /home/vagrant/signer.pass --mine --miner.gastarget 7500000 --miner.gaslimit 10000000 --miner.gasprice 1000000000
#geth --datadir=/home/vagrant/.ethereum2 --networkid 777 --cache 512 --port 30501 --nat extip:192.168.66.66 --maxpeers 50  --ethstats 'sealer02:test7@stats.eth.devel' --bootnodes enode://818264acf4097e89dd7d7c3ea5fd7844a9f49389567b1ae22820464477f7897a9fb7932f690a973cde64b3815e4ed5bb0b4fe1476d67b6aae4dd616c4aef14ee@192.168.66.66:30303  --unlock 0 --password /home/vagrant/signer.pass --mine --miner.gastarget 7500000 --miner.gaslimit 10000000 --miner.gasprice 1000000000
# node1 add node2 enode address by admin.addPeer()

#curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' http://127.0.0.1:8545
