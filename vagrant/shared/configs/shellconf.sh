#!/bin/bash

HOST=$1
WEB=$2
API=$3

hostname $1
echo 'nameserver {[Your Domain DNS IP]}' >> /etc/resolv.conf
echo 'search {[Your Domain Name]}' >> /etc/resolv.conf
echo 'deb http://debian.saltstack.com/debian wheezy-saltstack-017 main' | sudo tee -a /etc/apt/sources.list
wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
apt-get update

if [[ $HOST == *lb* ]]
then
    sudo sed -i 's/###lbServer-web###/'$WEB'/g' /etc/nginx/nginx.conf
    sudo sed -i 's/###lbServer-api###/'$API'/g' /etc/nginx/nginx.conf
    sudo nginx -s reload
fi

exit
