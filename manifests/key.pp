define ceph::key (
  $secret       = undef,
  $keyring_path = "/var/lib/ceph/tmp/${name}.keyring",
  $user = 'root',
  $group = 'root',
  $mode = '0660',
) {

  exec { "ceph-key-${name}":
    command => "ceph-authtool ${keyring_path} --create-keyring --name='client.${name}' --add-key='${secret}'",
    creates => $keyring_path,
    require => Package['ceph'],
    notify => File[$keyring_path]
  }
  file { $keyring_path:
    mode => $mode,
    owner => $user,
    group => $group,
    require => Exec["ceph-key-${name}"]
  }
  Exec["ceph-key-${name}"] -> File["$keyring_path"]
}
