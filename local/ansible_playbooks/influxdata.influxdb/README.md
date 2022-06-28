Influxdb v2 TLS/SSL off (can be enabled)

need gnupg installed on host

ansible-playbook -i hosts.yml influxdb.yml -v

Output of this playbook - RW token for all created buckets

/roles/influxdb2/defaults/main.yml - place buckets names and retention settings here, username, password

/roles/influxdb2/templates/config.yml.j2 - place host memory settings here

/roles/influxdb2/defaults/main.yml - place org, chain for deployment

/roles/influxdb2/vars/ - buckets names, retention, shard group duration settings, task settings
