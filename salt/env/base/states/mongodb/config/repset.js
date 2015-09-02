{% if 'dev' in grains['host'] %}
{% set environment = 'dev' %}
{% elif 'qa' in grains['host']  %}
{% set environment = 'qa' %}
{% elif 'rc' in grains['host']  %}
{% set environment = 'rc' %}
{% elif 'prod' in grains['host']  %}
{% set environment = 'prod' %}
{% endif %}


rs.initiate({
_id : "rs0",
    members : [
       { _id : 0, host : "{{environment}}-db1" },
       { _id : 1, host : "{{environment}}-db2" },
       { _id : 2, host : "{{environment}}-db3" },
    ]
})
