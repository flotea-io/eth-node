#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

info "Restart web-stack"
service nginx restart
service ethnode start

info "Main - Hello Dev - You probably can try do something now"
echo "Provision-script user: `whoami`"
echo "IP: 192.168.66.66"
