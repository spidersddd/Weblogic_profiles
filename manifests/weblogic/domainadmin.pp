class profile::weblogic::domainadmin {
  $wls_os_user = hiera('wls_os_user')
  $wls_os_group = hiera('wls_os_group')
  $wls_domain = $::wls_domain
  $wsl_domain_path = hiera('dft_wls_domains_path')

  class { 'orautils':
    osMdwHomeParam    => hiera('wls_middleware_home_dir'),
    osWlHomeParam     => hiera('wls_weblogic_home_dir'),
    oraUserParam      => $wls_os_user,
    oraGroupParam     => $wls_os_group,
    osDomainParam     => $wls_domain,
    osDomainPathParam => "${wls_domains_path}/${wls_domain}",
  }

  include weblogic::services::domains
  include weblogic::services::nodemanager
  include weblogic::services::startwls
  include weblogic::services::userconfig

  include weblogic::services::security
  include weblogic::services::basic_config

  Class['orautils'] ->
  Class['weblogic::services::domains'] ->
  Class['weblogic::services::nodemanager'] ->
  Class['weblogic::services::startwls'] # ->
  Class['weblogic::services::userconfig'] ->
  Class['weblogic::services::security'] ->
  Class['weblogic::services::basic_config']
  
}
