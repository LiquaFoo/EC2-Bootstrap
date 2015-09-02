include:
  - .init

{% if 'dev' in grains['host'] %}
{% set environment = 'dev' %}
{% elif 'qa' in grains['host']  %}
{% set environment = 'qa' %}
{% elif 'rc' in grains['host']  %}
{% set environment = 'rc' %}
{% elif 'prod' in grains['host']  %}
{% set environment = 'prod' %}
{% endif %}


/usr/libexec/mongo/check_mongocfg_status.sh:
  file.managed:
    - source: salt://states/mongodb/config/check_mongocfg_status.sh 
    - user: root
    - mode: 777
    - template: jinja

mongod-config:
  cmd:
    - run
    - name: mongos --configdb {{ environment }}-dbcfg1:27019,{{ environment }}-dbcfg2:27019,{{ environment }}-dbcfg3:27019 --fork --logpath /var/log/mongodb/mongos.log
    - onlyif: /usr/libexec/mongo/check_mongocfg_status.sh
    - require:
       - pkg: mongodb-server
       - file: /usr/libexec/mongo/check_mongocfg_status.sh
