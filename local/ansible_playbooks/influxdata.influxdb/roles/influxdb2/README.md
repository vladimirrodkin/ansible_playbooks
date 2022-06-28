![](/images/logo.png)
# ndaal_ansible_role_influxdb2

Ansible role for InfluxDB 2.0 with TLS encryption.

## Description

This role generates self-signed certificate and pass as a runtime parameter to Influxd command. Hence influxdb2 endpoint is accessible via HTTPS (TLS enabled).


## Pre-requisite

- [ ] Python 3
- [ ] Python3-pip
- [ ] [Docker](https://docs.docker.com/engine/install/)

Run following command in the shell for package installation.

``
pip3 install -r requirements.txt
``

## Dependencies

A Role named common is included and should work as a dependency For Debian 11.

## Role variables

These variables should be setup to use this role. These variables are declared in default/main.yml

| Variable  | Default | Description |
| ---  | --- | --- |
| influxdb_user | admin | Name of the Influxdb user
| influxdb_password | &lt; _secret_ &gt; | This variable is encrypted with Ansible vault in vars/main.yml ( _vault key: 12345678_ )
| influxdb_ip_address | ansible_hostname | Influxdb host ip address
| influxdb_bucket | measure | Name of Influxdb bucket
| influxdb_org | ndaal | Organisation ID / name
| influxdb_enc_algo| Ed25519 | Choose Encryption Algorithm such as: DSA, ECC, Ed25519, RSA etc
| selfsigned| true | While using self signed certificate and want to skip verification of the certificate, set value `true`. In order to use properly signed certificate by Certification Authority, configure the certificate paths in defaults, and set this variable to `false`.

## Example Playbook

Including an example of how to use your role.

```
---
- hosts: all
  roles:
    - ndaal_ansible_role_influxdb2
```
## Testing

Set *ansible-vault-password-file* in `molecule.yml` file in `molecule/default` directory. Run Molecule test to test the code.

``
molecule test
``

## Roadmap
This is a first attempt to make Influxdb v2.0 with TLS  run via Ansible. Right now, we are creating self-signed certifcates directly on the host and implmentation to import external certificate is needed. Also systemd is incorporated to the role to make Influxdb v2.0 service more manageable.

## Contributing
Any Contribution to improve the role is welcome. Please see Roadmap for features and improvements.

## Authors and acknowledgment

[Mamoona Aslam](mamoona.aslam@ndaal.eu) / ndaal Gesellschaft für Sicherheit in der Informationstechnik mbH & Co KG in Cologne

## License
[The GNU General Public License, Version 3](LICENSE)
