set-dns:
  cmd.run:
    - tgt: '*dc1*'
    - name: dnscmd dc1 /RecordAdd {[Your Domain Name]} {{pillar['host']}} A {{pillar['ip']}}
