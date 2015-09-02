nginx:
  pkg.installed

nginx-svc:
  service:
    - running
    - name: nginx
    - enable: True
    - reload: True

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://states/nginx/conf/nginx.conf
    - user: root
    - mode: 777
    - template: jinja

reload-conf:
  cmd.run:
    - name: nginx -s reload
