{% if 'dev' in grains['host'] %}
{% set environment = 'dev' %}
{% elif 'qa' in grains['host']  %}
{% set environment = 'qa' %}
{% elif 'rc' in grains['host']  %}
{% set environment = 'rc' %}
{% elif 'prod' in grains['host']  %}
{% set environment = 'prod' %}
{% endif %}

sh.addShard( "rs0/{{ environment }}-db1:27017" )
