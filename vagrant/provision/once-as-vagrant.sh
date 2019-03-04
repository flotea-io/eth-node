#!/usr/bin/env bash

info "Provision-script user: `whoami`"

info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc

info "Generate 3 Accounts with passwd: testpasswd"
geth --datadir .ethereum/ account new --password <(echo testpasswd)
geth --datadir .ethereum/ account new --password <(echo testpasswd)
geth --datadir .ethereum/ account new --password <(echo testpasswd)
info "Generated Accounts"
geth account list
echo "Done!"

ACC_MAIN=`geth --verbosity 0 account list | grep -Po "\#0: {(.*?)\}" | cut -d "{" -f2 | cut -d "}" -f1`
ACC_01=`geth --verbosity 0 account list | grep -Po "\#1: {(.*?)\}" | cut -d "{" -f2 | cut -d "}" -f1`
ACC_02=`geth --verbosity 0 account list | grep -Po "\#2: {(.*?)\}" | cut -d "{" -f2 | cut -d "}" -f1`

info "Generate PoA Chain Puppeth"
printf 'flotea\n2\n1\n2\n15\n'$ACC_MAIN'\n\n'$ACC_01'\n'$ACC_02'\n\nno\n777\n2\n2\n\n' | puppeth
echo "Done!"

info "Init Blockchain"
geth --datadir .ethereum/ init flotea.json
echo "Done!"

#curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' http://127.0.0.1:8545
