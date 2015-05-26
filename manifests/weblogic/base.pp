class profile::weblogic::base (
  $wls_filename          = $profile::weblogic::params::wls_filename,
  $wls_version           = $profile::weblogic::params::wls_version,
  $wls_os_user           = $profile::weblogic::params::wls_os_user,
  $wls_os_group          = $profile::weblogic::params::wls_os_group,
  $wls_domain            = $::wls_domain,
  $weblogic_home_dir     = $profile::weblogic::params::wls_weblogic_home_dir,
  $middleware_home_dir   = $profile::weblogic::params::wls_middleware_home_dir,
  $oracle_base_home_dir  = $profile::weblogic::params::wls_oracle_base_home_dir,
  $jdk_home_dir          = $profile::weblogic::params::jdk_home_dir,
  $oracle_home_dir       = $profile::weblogic::params::wls_oracle_home_dir,
  $download_dir          = $profile::weblogic::params::download_dir,
  $source                = $profile::weblogic::params::source,
  $fmw_plugins           = hiera_hash('fmw_installations', {}),
  $apps_dir              = $profile::weblogic::params::apps_dir,
  $opatch                = hiera_hash('profile::weblogic::base::opatch', {}),
  $domains_dir           = $profile::weblogic::params::wls_domains_path,
  )  inherits profile::weblogic::params {

  validate_string( "$wls_install_jar", "$wls_os_user", "$wls_os_group", "$wls_domain", "$source" )
  # notify{"$wls_install_jar $wls_os_user $wls_os_group $wls_domain $source":}
#  validate_absolute_path( "$weblogic_home_dir", "$middleware_home_dir", "$oracle_base_home_dir", "$jdk_home_dir", "$oracle_home_dir", "$download_dir", "$domains_dir" )

  $default = {
    weblogic_home_dir    => $weblogic_home_dir,
    middleware_home_dir  => $middleware_home_dir,
    oracle_base_home_dir => $oracle_base_home_dir,
    jdk_home_dir         => $jdk_home_dir,
    os_user              => $wls_os_user,
    os_group             => $wls_os_group,
    download_dir         => $download_dir,
    source               => $source,
  }

  Host <<| tag == $wls_domain |>>

  profile::websphere::mount { '/tmp/webhosting': }

  contain profile::weblogic::java

  class { '::weblogic::utils::user':
    user_name     => $wls_os_user,
    user_group    => $wls_os_group,
    user_home     => "/home/${wls_os_user}",
    user_password => '$1$v4K9E8Wj$gZIHJ5JtQL5ZGZXeqSSsd0',
    require       => Profile::Websphere::Mount['/tmp/webhosting'],
  }

  class { '::weblogic::os':
    host_instances => {},
    install_jdk    => false,
    java_homes     => '/usr/java/latest',
  }

  class { '::weblogic::urandomfix': }

  class { '::weblogic::ssh':
    os_user  => $wls_os_user,
    os_group => $wls_os_group,
  }
  
  class { '::weblogic::provision':
   version              => $wls_version,
   filename             => $wls_filename,
   export_dir           => $download_dir,
   source               => $source,
   temp_directory       => '/tmp',
   oracle_base_home_dir => $oracle_base_home_dir,
   middleware_home_dir  => $middleware_home_dir,
   wls_domains_dir      => $domains_dir,
   os_user              => $wls_os_user,
   os_group             => $wls_os_group,
   jdk_home_dir         => $jdk_home_dir,
   wls_apps_dir         => $apps_dir,
   download_dir         => $download_dir,
 }
    
  include ::weblogic::services::bsu

  class { 'orautils':
    osMdwHomeParam        => $middleware_home_dir,
    osWlHomeParam         => $weblogic_home_dir,
    oraUserParam          => $wls_os_user,
    oraGroupParam         => $wls_os_group,
    osDomainParam         => $wls_domain,
    osDomainPathParam     => "${domains_dir}/${wls_domain}",
    osDownloadFolderParam => $download_dir,
    nodeMgrPathParam      => "${weblogic_home_dir}/server/bin"
  }

  class { '::weblogic::services::opatch':
    default_params   => $default,
    opatch_instances => $opatch,
  }

  class { '::weblogic::services::fmw':
    default_params    => $default,
    fmw_installations => $fmw_plugins,
  }

  Class['profile::weblogic::java'] ->
  Class['weblogic::utils::user'] ->
  Class['weblogic::os'] ->
  Class['weblogic::urandomfix'] ->
  Class['weblogic::ssh'] ->
  Class['weblogic::provision'] ->
  Class['orautils'] ->
  Class['weblogic::services::opatch'] ->
  Class['weblogic::services::bsu'] ->
  Class['weblogic::services::fmw']
}

