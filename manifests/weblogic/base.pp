class profile::weblogic::base {
  $wls_os_user = hiera('wls_os_user')
  $wls_os_group = hiera('wls_os_group')
  $wls_domain = $::wls_domain
  contain profile::weblogic::java

  class { 'weblogic::utils::user':
    user_name     => $wls_os_user,
    user_group    => $wls_os_group,
    user_home     => "/home/$wls_os_user",
    user_password => '$1$v4K9E8Wj$gZIHJ5JtQL5ZGZXeqSSsd0',
  }
  
  class { 'weblogic::os':
    host_instances => {},
    install_jdk    => false,
    java_homes     => '/usr/java/latest',
  }

  class { 'weblogic::urandomfix': }

  include weblogic::ssh
  
  class { 'weblogic::provision': 
    version               =>  '1036',
    filename              =>  'wls1036_generic.jar',
    export_dir            =>  '/tmp/oracle',
    source                =>  '/vagrant/oracle',
    temp_directory        =>  '/tmp',
  }
    
  include weblogic::services::opatch

  Class['profile::weblogic::java'] ->
  Class['weblogic::utils::user'] ->
  Class['weblogic::os'] ->
  Class['weblogic::urandomfix'] ->
  Class['weblogic::ssh'] ->
  Class['weblogic::provision'] ->
#  Class['orautils'] 
  Class['weblogic::services::opatch']
}

