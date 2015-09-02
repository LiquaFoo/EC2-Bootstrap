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


exit | mongo --host {{ environment }}-db1:27019 > /dev/null 2>&1
while [ $? -ne 0 ]; do
    echo 'Testing connection to db1'
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-db1:27019 > /dev/null 2>&1
done

exit | mongo --host {{ environment }}-db2:27019 > /dev/null 2>&1
while [ $? -ne 0 ]; do
    echo 'Testing connection to db2'
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-db2:27019 > /dev/null 2>&1
done

exit | mongo --host {{ environment }}-db3:27019 > /dev/null 2>&1
while [ $? -ne 0 ]; do
    echo 'Testing connection to db3'
    echo -n "."
    sleep 1
    echo exit | mongo --host {{ environment }}-db3:27019 > /dev/null 2>&1
done

exit
