include:
  - .init

mongo-dirs:
  file:
    - directory
    - user: root
    - mode: 600
    - makedirs: True
    - names:
      - /var/log/mongodb
      - /etc/mongod
      - /usr/libexec/mongo     
      {% if 'dev' in grains['host'] or 'qa' in grains['host'] %}
      - /var/lib/mongodb/node1
      - /var/lib/mongodb/node2
      - /var/lib/mongodb/arbiter
      {% else %}
      - /var/lib/mongodb/prod
      {% endif %}
    - require:
      - pkg: mongodb-server
      
{% if 'dev' in grains['host'] or 'qa' in grains['host'] %}

#copy config files
copy-dir:
  file.recurse:
    - name: /etc/mongod
    - source: salt://states/mongodb/config/dev/mongod
    - require:
      - file: mongo-dirs

#start daemons
mongo-start1:
 cmd.run:
   - name: mongod -f /etc/mongod/node1.conf  
   - require:
     - file: copy-dir
mongo-start2:
 cmd.run:
   - name: mongod -f /etc/mongod/node2.conf
   - require:
     - file: copy-dir
mongo-start3:
 cmd.run:
   - name: mongod -f /etc/mongod/arbiter.conf
   - require:
     - file: copy-dir 

{% else %}

#copy config files
copy-dir:
  file.recurse:
    - name: /etc/mongod
    - source: salt://states/mongodb/config/prod/mongod
    - require:
       - file: mongo-dirs

#start daemons
mongo-startProd:
 cmd.run:
   - name: mongod -f /etc/mongod/mongodb.conf
   - require:
     - file: copy-dir

{% endif %}

{% if 'db1'in grains['host'] and 'rt' not in grains['host'] and 'cfg' not in grains['host'] %}

#initiate replica set 
#copy over script
/usr/libexec/mongo/repset_init.js:
  file:
    - managed
    - source: salt://states/mongodb/config/repset.js
    - template: jinja
    - require:
      - file: mongo-dirs
#copy over script
/usr/libexec/mongo/rs_check_mongo_status.sh:
  file:
    - managed
    - source: salt://states/mongodb/config/rs_check_mongo_status.sh
    - mode: 777
    - template: jinja
    - require:
      - file: mongo-dirs
#run script
sudo mongo --quiet /usr/libexec/mongo/repset_init.js:
  cmd:
    - run
    - unless: /usr/libexec/mongo/rs_check_mongo_status.sh
    - user: root
    - group: root
    - require:
      - file: /usr/libexec/mongo/rs_check_mongo_status.sh
{% endif %}

{% if 'db1' in grains['host'] %}
/usr/libexec/mongo/mongos_add_shards.js:
  file:
    - managed
    - source: salt://states/mongodb/config/mongos_add_shards.js
    - mode: 777
    - template: jinja
    - require:
      - file: mongo-dirs

/usr/libexec/mongo/mongos_add_shards.sh:
  file:
    - managed
    - source: salt://states/mongodb/config/mongos_add_shards.sh
    - mode: 777
    - template: jinja
    - require:
      - file: mongo-dirs

mogos-add-shards:
  cmd:
   - run
   - name: /usr/libexec/mongo/mongos_add_shards.sh
   - user: root
   - group: root
   - require:
     - file: /usr/libexec/mongo/mongos_add_shards.sh
     - file: /usr/libexec/mongo/mongos_add_shards.js
{% endif %}

#{% if 'db'in grains['host'] and 'rt' not in grains['host'] and 'cfg' not in grains['host'] and 'db1' not in grains['host'] %}
#copy over scripts
#/usr/libexec/mongo/remote_add_member.sh:
#  file:
#    - managed
#    - source: salt://states/mongodb/remote_add_member.sh
#    - mode: 777
#    - require:
#      - file: mongo-dirs
#/usr/libexec/mongo/rs_mongo_add_member.js:
#  file:
#    - managed
#    - source: salt://states/mongodb/rs_mongo_add_member.js
#    - mode: 777
#    - template: jinja
#    - require:
#      - file: mongo-dirs
#run script
#mongo-add-member:
#  cmd.run:
#    - name: /usr/libexec/mongo/remote_add_member.sh {{ grains['host'] }}
#    - user: root
#    - group: root
#    - require:
#      - file: /usr/libexec/mongo/remote_add_member.sh
#      - file: /usr/libexec/mongo/rs_mongo_add_member.js
#      - pkg: mongodb-server
#{% endif %}
