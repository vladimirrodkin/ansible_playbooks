import os
import re
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_influxdb_is_installed(host):
    cmd = host.run("influxd version")
    assert cmd.rc == 0
    pattern = re.compile("^InfluxDB v[\\d.]+")
    assert pattern.match(cmd.stdout)