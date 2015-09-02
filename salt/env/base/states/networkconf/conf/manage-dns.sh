#!/bin/bash

HOST=$(hostname)
IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

ssh -t -t -i /usr/libexec/salt/build.pem -o StrictHostKeyChecking=no ubuntu@cfm << ENDSSH
sudo salt '*dc1*' state.sls states.networkconf.dns queue=True pillar="{host: $HOST, ip: $IP}" --verbose
exit
ENDSSH

exit
