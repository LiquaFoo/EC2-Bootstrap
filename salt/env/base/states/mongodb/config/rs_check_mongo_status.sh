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


echo -n "Testing that mongo connection is available"
echo exit | mongo > /dev/null 2>&1

while [ $? -ne 0 ]; do
    echo -n "."
    sleep 1
    echo exit | mongo > /dev/null 2>&1
done

echo exit | mongo --host {{ environment }}-db2 > /dev/null 2>&1

while [ $? -ne 0 ]; do
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-db2 > /dev/null 2>&1
done

echo exit | mongo --host {{ environment }}-db3 > /dev/null 2>&1

while [ $? -ne 0 ]; do
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-db3 > /dev/null 2>&1
done


echo "Mongo connection available, and checking the replica status."

if [ `mongo --quiet --eval "rs.status()['ok']"` == "1" ]; then
    echo "Mongo replica set is initialized properly"
    exit 0
else
    echo "Mongo replica set is not initialized, and needs config object"
    exit 1
fi

