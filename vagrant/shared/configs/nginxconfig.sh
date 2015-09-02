#!/bin/bash

HOST=$1
WEB=$2
API=$3

#ssh -t -t -i /srv/vagrant/shared/keys/build.pem -o StrictHostKeyChecking=no ubuntu@$HOST << ENDSSH
	sed -i 's/###lbServer-web###/'"$WEB"'/g' /etc/nginx/nginx.conf
	sed -i 's/###lbServer-api###/'"$API"'/g' /etc/nginx/nginx.conf
        nginx -s reload
#exit
#ENDSSH

exit 0
