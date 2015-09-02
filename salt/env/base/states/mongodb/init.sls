mongodb-server:
 pkg.installed:
  - name: mongodb-server
  - skip_verify: True
  - skip_suggestions: True
  - version: 1:2.4.6-0ubuntu5

mongodb:
 service:
  - dead
  - require:
     - pkg: mongodb-server
