likewise-open:
  pkg.installed

dhclient-conf:
  file.managed:
    - name: /etc/dhcp/dhclient.conf
    - source: salt://states/networkconf/conf/dhclient.conf
    - user: root
    - mode: 777

resolv-conf:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://states/networkconf/conf/resolv.conf
    - user: root
    - mode: 777

networking:
  cmd.run:
    - name: sudo service networking restart

register-host:
  cmd.run:
    - name: domainjoin-cli join {[Your Domain Name]} {Domain Admin User} {Domain Admin Password}

/usr/libexec/salt/:
  file.directory:
    - makedirs: True
    - user: root
    - dir_mode: 777

/usr/libexec/salt/build.pem:
  file.managed:
    - source: salt://states/networkconf/conf/build.pem
    - user: root
    - mode: 600

/usr/libexec/salt/manage-dns.sh:
  file.managed:
    - source: salt://states/networkconf/conf/manage-dns.sh
    - user: root
    - mode: 777

update-dns:
  cmd.run:
    - name: /usr/libexec/salt/manage-dns.sh
