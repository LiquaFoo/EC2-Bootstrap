{% if 'dev' in grains['host'] %}
{% set environment = 'dev' %}
{% elif 'qa' in grains['host']  %}
{% set environment = 'qa' %}
{% elif 'rc' in grains['host']  %}
{% set environment = 'rc' %}
{% elif 'prod' in grains['host']  %}
{% set environment = 'prod' %}
{% endif %}

{% if 'web' in grains['host'] %}
{% set directory = 'app' %}
{% elif 'api' in grains['host']  %}
{% set directory = 'api' %}
{% endif %}

node-server-stop:
  service:
   - name: node-server
   - dead

create-directory:
  file.directory:
   - name: /var/apps/www/{{ directory }}
   - user: root
   - group: root
   - dir_mode: 777
   - recurse:
      - user
      - group
      - mode
   - clean: True
   - makedirs: True

copy-dir:
  file.recurse:
    - name: /var/apps/www/{{ directory }}
    - user: root
    - dir_mode: 0777
    - file_mode: '0777'
    - source: salt://deploy/{{ environment }}/{{ directory }}
    - include_empty: True

node-server-start:
  service:
   - name: node-server
   - running
