class profile::weblogic::nodemanager2 (

  $wls_filename                          = $profile::weblogic::params::wls_filename,
  $wls_version                           = $profile::weblogic::params::wls_version,
  $wls_os_user                           = $profile::weblogic::params::wls_os_user,
  $wls_os_group                          = $profile::weblogic::params::wls_os_group,
  $wls_domain                            = $::wls_domain,
  $weblogic_home_dir                     = $profile::weblogic::params::wls_weblogic_home_dir,
  $middleware_home_dir                   = $profile::weblogic::params::wls_middleware_home_dir,
  $oracle_base_home_dir                  = $profile::weblogic::params::wls_oracle_base_home_dir,
  $jdk_home_dir                          = $profile::weblogic::params::jdk_home_dir,
  $oracle_home_dir                       = $profile::weblogic::params::wls_oracle_home_dir,
  $download_dir                          = $profile::weblogic::params::download_dir,
  $source                                = $profile::weblogic::params::source,
  $log_output                            = $profile::weblogic::params::wls_log_output,
  $log_dir                               = $profile::weblogic::params::wls_log_dir,
  $apps_dir                              = $profile::weblogic::params::apps_dir,
  $domains_dir                           = $profile::weblogic::params::wls_domains_path,
  $development_mode                      = $profile::weblogic::params::development_mode,
  $adminserver_address                   = $profile::weblogic::params::adminserver_address,
  $adminserver_name                      = $profile::weblogic::params::adminserver_name,
  $adminserver_port                      = $profile::weblogic::params::adminserver_port,
  $java_arguments                        = $profile::weblogic::params::java_arguments,
  $nodemanager_address                   = $::ipaddress_eth1,
  $nodemanager_port                      = $profile::weblogic::params::nodemanager_port,
  $weblogic_user                         = $profile::weblogic::params::wls_weblogic_user,
  $weblogic_password                     = $profile::weblogic::params::wls_weblogic_password,
  $webtier_enabled                       = $profile::weblogic::params::webtier_enabled,
  $custom_trust                          = $profile::weblogic::params::custom_trust,
  $trust_keystore_file                   = $profile::weblogic::params::trust_keystore_file,
  $trust_keystore_passphrase             = $profile::weblogic::params::trust_keystore_passphrase,
  $custom_identity                       = $profile::weblogic::params::custom_identity,
  $custom_identity_keystore_filename     = $profile::weblogic::params::custom_identity_keystore_filename,
  $custom_identity_keystore_passphrase   = $profile::weblogic::params::custom_identity_keystore_passphrase,
  $custom_identity_alias                 = $profile::weblogic::params::custom_identity_alias,
  $custom_identity_privatekey_passphrase = $profile::weblogic::params::custom_identity_privatekey_passphrase,
  $create_rcu                            = $profile::weblogic::params::create_rcu,
  $file_domain_libs                      = hiera('file_domain_libs', {}),
  $fmw_plugins                           = hiera_hash('fmw_installations', {}),
  $opatch                                = hiera_hash('profile::weblogic::base::opatch', {}),
  #$default_params                        = hiera('wls_default_params', {}),

  )  inherits profile::weblogic::params {


  $default_params = { }

  anchor { 'profile::weblogic::nodemanager::begin':
    before => Anchor['profile::weblogic::nodemanager::end'],
  }

  contain profile::weblogic::base

  profile::weblogic::export_service_host { $::fqdn:
    service => 'nodemanager',
  }

  weblogic::copydomain { $wls_domain:
    version             => $wls_version,
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    jdk_home_dir        => $jdk_home_dir,
    wls_domains_dir     => $domains_dir,
    wls_apps_dir        => $apps_dir,
    use_ssh             => true,
    domain_pack_dir     => $download_dir,
    domain_name         => $wls_domain,
    adminserver_address => $adminserver_address,
    adminserver_port    => $adminserver_port,
    weblogic_user       => $weblogic_user,
    weblogic_password   => $weblogic_password,
    os_user             => $wls_os_user,
    os_group            => $wls_os_group,
    download_dir        => $download_dir,
    log_dir             => $log_dir,
    log_output          => $log_output,
    #userConfigFile     =>
    #userKeyFile
    require             => Class['profile::weblogic::base'],
  }

  # wls_setting { 'default':
  #  user              => $wls_os_user,
  #  weblogic_home_dir => $weblogic_home_dir,
  #  connect_url       => "t3://${adminserver_address}:${adminserver_port}",
  #  weblogic_user     => $weblogic_user,
  #  weblogic_password => $weblogic_password,
  #  require           => Weblogic::Copydomain[$wls_domain],
  #}

  Wls_setting <<| tag == $wls_domain |>>

  weblogic::nodemanager { "${wls_domain}_nm":
    version                               => $wls_version,
    middleware_home_dir                   => $middleware_home_dir,
    weblogic_home_dir                     => $weblogic_home_dir,
    nodemanager_port                      => $nodemanager_port,
    nodemanager_address                   => $nodemanager_address,
    nodemanager_secure_listener           => true,
    jsse_enabled                          => true,
    custom_trust                          => $custom_trust,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    custom_identity                       => $custom_identity,
    custom_identity_keystore_filename     => $custom_identity_keystore_filename,
    custom_identity_keystore_passphrase   => $custom_identity_keystore_passphrase,
    custom_identity_alias                 => $custom_identity_alias,
    custom_identity_privatekey_passphrase => $custom_identity_privatekey_passphrase,
    wls_domains_dir                       => $domains_dir,
    domain_name                           => $wls_domain,
    jdk_home_dir                          => $jdk_home_dir,
    os_user                               => $wls_os_user,
    os_group                              => $wls_os_group,
    download_dir                          => $download_dir,
    log_dir                               => $log_dir,
    log_output                            => $log_output,
    sleep                                 => 20,
    #    require                               => Wls_setting['default'],
  }

  weblogic::control { "startWLS${wls_domain}":
    domain_name      => $wls_domain,
    server_type      => 'managed',
    target           => 'Cluster',
    server           => "WebCluster",
    action           => 'start',
    adminserver_port => $adminserver_port,
    log_output       => $log_output,
    require          => Wls_setting['default'],
  }

  anchor { 'profile::weblogic::nodemanager::end':
    require => [ Anchor['profile::weblogic::nodemanager::begin'],
      Weblogic::Nodemanager["${wls_domain}_nm"],
    ],
  }
  
}
