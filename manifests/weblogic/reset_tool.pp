class profile::weblogic::reset_tool {
  file { '/root/reset_host':
    ensure  => present,
    source  => 'puppet:///modules/profile/weblogic/reset_host',
    mode    => '0755',
  }
  file { '/root/reset.pp':
    ensure  => present,
    source  => 'puppet:///modules/profile/weblogic/reset.pp',
  }
}
