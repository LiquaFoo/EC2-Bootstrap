include:
  - .init

/data/configdb:
  file.directory:
   - user: root
   - group: root
   - dir_mode: 777
   - recurse:
      - user
      - group
      - mode
   - makedirs: True
   - require: 
      - pkg: mongodb-server


mongod-config:
 cmd.run:
   - name: mongod --configsvr --dbpath /data/configdb --port 27019 --fork --logpath /var/log/mongodb/mongocfg.log
   - require:
     - file: /data/configdb
