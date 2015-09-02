nodejs:
 pkg.installed:
  - name: nodejs
  - skip_suggestions: True
  - skip_verify: True
  - refresh: True

npm:
 pkg.installed:
  - name: npm
  - skip_suggestions: True
  - skip_verify: True
  - version: 1.2.18~dfsg-3
  - refresh: True
  - require: 
    - pkg: nodejs

node-ln:
 cmd.run:
   - name: ln -s /usr/bin/nodejs /usr/bin/node

grunt-cli:
 npm:
  - installed
  - require:
     - pkg: npm

gulp:
 npm:
  - installed
  - require:
     - pkg: npm

/etc/init/node-server.conf:
  file.managed:
   - source: salt://states/node/config/node-server.conf
   - user: root
   - mode: 600
   - template: jinja
