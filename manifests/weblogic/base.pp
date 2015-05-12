class profile::weblogic::base (
  $wls_os_user           = hiera('profile::weblogic::os_user', 'webadmin'),
  $wls_os_group          = hiera('profile::weblogic::os_group', 'webadmns'),
  $wls_domain            = $::wls_domain,
	$wls_domain_path       = hiera('dft_wls_domains_path'),
  $weblogic_home_dir     = hiera('profile::weblogic::weblogic_home_dir', '/opt/was/oracle//middleware/wlserver_10.3/'),
  $middleware_home_dir   = hiera('profile::weblogic::middleware_home_dir', '/opt/was/oracle/middleware'),  
  $oracle_base_home_dir  = hiera('profile::weblogic::oracle_base_home_dir', '/opt/was/oracle'), 
  $jdk_home_dir          = hiera('profile::weblogic::jdk_home_dir', '/usr/java/latest'),
  $oracle_home_dir       = hiera('profile::weblogic::oracle_base_home_dir', '/opt/was/oracle/Oracle'),
  $download_dir          = hiera('profile::weblogic::download_dir', '/vagrant/oracle'),
  $source                = hiera('profile::weblogic::source', undef),
  $fmw_plugins           = hiera_hash('profile::weblogic::base::addons', {}),
  $apps_dir              = hiera('profile::weblogic::apps_dir', undef),
  $domains_dir           = hiera('profile::weblogic::domains_dir', undef),
  $opatch                = hiera_hash('profile::weblogic::base::opatch', {}),
  )  {

  $default = { 
    weblogic_home_dir    => "$weblogic_home_dir",
    middleware_home_dir  => "$middleware_home_dir",
    oracle_base_home_dir => "$oracle_base_home_dir", 
    jdk_home_dir         => "$jdk_home_dir",
    os_user              => "$wls_os_user",
    os_group             => "$wls_os_group",
    download_dir         => "$download_dir",
    source               => "$source",
  }
  
  contain profile::weblogic::java

  class { '::weblogic::utils::user':
    user_name     => $wls_os_user,
    user_group    => $wls_os_group,
    user_home     => "/home/$wls_os_user",
    user_password => '$1$v4K9E8Wj$gZIHJ5JtQL5ZGZXeqSSsd0',
  }

  class { '::weblogic::os':
    host_instances => {},
    install_jdk    => false,
    java_homes     => '/usr/java/latest',
  }

  class { '::weblogic::urandomfix': }

  class { '::weblogic::ssh':
    os_user  => "$wls_os_user",
    os_group => "$wls_os_group",
  }
  
  class { '::weblogic::provision': 
    version               =>  '1036',
    filename              =>  'wls1036_generic.jar',
    export_dir            =>  '/tmp/oracle',
    source                =>  $source,
    temp_directory        =>  '/tmp',
    oracle_base_home_dir  => $oracle_base_home_dir,
    middleware_home_dir   => $middleware_home_dir,
    wls_domains_dir       => $domains_dir,
    os_user               => $wls_os_user,
    os_group              => $wls_os_group,
    jdk_home_dir          => $jdk_home_dir,
    wls_apps_dir          => $apps_dir,
    download_dir          => $download_dir,
  }
    
#  include ::weblogic::services::bsu

  class { 'orautils':
    osMdwHomeParam    => $middleware_home_dir,
    osWlHomeParam     => $weblogic_home_dir,
    oraUserParam      => $wls_os_user,
    oraGroupParam     => $wls_os_group,
    osDomainParam     => $wls_domain,
    osDomainPathParam => "${domains_dir}/${wls_domain}",
  }
#
  class { '::weblogic::services::opatch':
    default_params   => $default,
    opatch_instances => $opatch, 
  }
#
  class { '::weblogic::services::fmw':
    default_params => $default,
    fmw_installations => $fmw_plugins,
  }   
#
#
  Class['profile::weblogic::java'] ->
  Class['weblogic::utils::user'] ->
  Class['weblogic::os'] ->
  Class['weblogic::urandomfix'] ->
  Class['weblogic::ssh'] ->
  Class['weblogic::provision'] ->
  Class['orautils'] ->
  Class['weblogic::services::opatch'] ->
#  Class['weblogic::services::bsu'] ->
  Class['weblogic::services::fmw']
}

