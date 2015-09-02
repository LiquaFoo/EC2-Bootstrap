#!/bin/bash

{% if 'dev' in grains['host'] %}
{% set environment = 'dev' %}
{% elif 'qa' in grains['host']  %}
{% set environment = 'qa' %}
{% elif 'rc' in grains['host']  %}
{% set environment = 'rc' %}
{% elif 'prod' in grains['host']  %}
{% set environment = 'prod' %}
{% endif %}


while [ `mongo --quiet --eval "rs.status().members.length"` -lt 3 ]; do
    echo -n "."
    sleep 1
done

echo exit | mongo --host {{ environment }}-dbrt1 > /dev/null 2>&1

while [ $? -ne 0 ]; do
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-dbrt1 > /dev/null 2>&1
done

sleep 20

mongo --host {{ environment }}-dbrt1 --quiet /usr/libexec/mongo/mongos_add_shards.js

exit
