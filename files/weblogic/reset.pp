
file { '/etc/oraInst.loc':
  ensure  => absent,
  recurse => true,
  purge  => true,
  force  => true,
}

file { '/tmp/oracle':
  ensure  => absent,
  recurse => true,
  purge  => true,
  force  => true,
}

file { '/opt/was/oracle':
  ensure  => absent,
  recurse => true,
  purge  => true,
  force  => true,
}

file { '/app/oracle':
  ensure  => absent,
  recurse => true,
  purge  => true,
  force  => true,
}

file { '/usr/java':
  ensure  => absent,
  recurse => true,
  purge  => true,
  force  => true,
}

file { '/usr/bin/java':
  ensure  => absent,
}

service { 'iptables':
  ensure => stopped
}

package { 'rng-tools':
  ensure => absent,
}
