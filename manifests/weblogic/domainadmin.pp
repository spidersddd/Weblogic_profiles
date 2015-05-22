# == Class: profile::weblogic::domainadmin
#
# This class is to build a domain admin server
#  using the abrader-weblogic module.  The original
#  orawls module was to dependant on hiera, and was
#  confusing to work with.  This is a profile that 
#  works to remove some complexity, but with that removes
#  some of the flexability that weblogic has.  It is
#  built to have some sane defaults around the services.
class profile::weblogic::domainadmin (
#  include weblogic::services::domains

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
  $fmw_plugins                           = hiera_hash('fmw_installations', {}),
  $log_output                            = $profile::weblogic::params::wls_log_output,
  $log_dir                               = $profile::weblogic::params::wls_log_dir,
  $apps_dir                              = $profile::weblogic::params::apps_dir,
  $opatch                                = hiera_hash('profile::weblogic::base::opatch', {}),
  $domains_dir                           = $profile::weblogic::params::wls_domains_path,
  $development_mode                      = $profile::weblogic::params::development_mode,
  $adminserver_name                      = $profile::weblogic::params::adminserver_name,
  $adminserver_address                   = $::ipaddress_eth1,
  $adminserver_port                      = $profile::weblogic::params::adminserver_port,
  $java_arguments                        = $profile::weblogic::params::java_arguments,
  $jsse_enabled                          = $profile::weblogic::params::jsse_enabled,
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
  $userconfig_instances                  = hiera('userconfig_instances', {}),
  $user_instances                        = hiera('user_instances', {}),
  $group_instances                       = hiera('group_instances', {}),
  $authentication_provider_instances     = hiera('authentication_provider_instances', {}),
  $wls_domain_instances                  = hiera('wls_domain_instances', {}),
  $wls_adminserver_instances_domain      = hiera('wls_adminserver_instances_domain', {}),
  $machines_instances                    = hiera('machines_instances', {}),
  $server_instances                      = hiera('server_instances'),
  $wls_adminserver_instances_server      = hiera('wls_adminserver_instances_server', {}),
  $server_channel_instances              = hiera('server_channel_instances', {}),
  $cluster_instances                     = hiera('cluster_instances', {}),
  $coherence_cluster_instances           = hiera('coherence_cluster_instances', {}),
  $server_template_instances             = hiera('server_template_instances', {}),
  $mail_session_instances                = hiera('mail_session_instances', {}),
  #$default_params                        = hiera('wls_default_params', {}),

  )  inherits profile::weblogic::params {

  $default_params = { require           => Weblogic::Domain["$wls_domain"], }
  $storeuser_default_params = { require => Weblogic::Control["startWLS${adminserver_name}"], }
  $security_default_params = { require  => Weblogic::Control["startWLS${adminserver_name}"], }

  anchor { 'profile::weblogic::domainadmin::begin':
    before => Anchor['profile::weblogic::domainadmin::end'],
  }

  #@@host { $::fqdn:
  #  ensure    => present,
  #  ip        => $::ipaddress_eth1,
  #  host_aliases => [$::hostname, "domainadmin_${wls_domain}"],
  #  tag          => $wls_domain,
  #}

  profile::weblogic::export_service_host { $::fqdn:
    service => 'domainadmin',
  }

  contain profile::weblogic::base

  # Replaces weblogic::services::domain
  weblogic::domain { $wls_domain:
    version                               => $wls_version,
    jsse_enabled                          => $jsse_enabled,
    weblogic_home_dir                     => $weblogic_home_dir,
    middleware_home_dir                   => $middleware_home_dir,
    jdk_home_dir                          => $jdk_home_dir,
    wls_domains_dir                       => $domains_dir,
    wls_apps_dir                          => $apps_dir,
    domain_template                       => 'standard',
    domain_name                           => $wls_domain,
    development_mode                      => $development_mode,
    adminserver_address                   => $adminserver_address,
    adminserver_name                      => $adminserver_name,
    adminserver_port                      => $adminserver_port,
    nodemanager_address                   => $nodemanager_address,
    nodemanager_port                      => $nodemanager_port,
    weblogic_password                     => $weblogic_password,
    log_output                            => $log_output,
    log_dir                               => $log_dir,
    custom_trust                          => $custom_trust,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    custom_identity                       => $custom_identity,
    custom_identity_keystore_filename     => $custom_identity_keystore_filename,
    custom_identity_keystore_passphrase   => $custom_identity_keystore_passphrase,
    custom_identity_alias                 => $custom_identity_alias,
    custom_identity_privatekey_passphrase => $custom_identity_privatekey_passphrase,
  }

  create_resources('file', $file_domain_libs, $default_params)
  
  wls_setting { 'default':
    user              => $wls_os_user,
    weblogic_home_dir => $weblogic_home_dir,
    connect_url       => "t3://${adminserver_address}:${adminserver_port}",
    weblogic_user     => $weblogic_user,
    weblogic_password => $weblogic_password,
    require           => Weblogic::Domain[$wls_domain],
  }

  #Replaces weblogic::services::nodemanager
    @@weblogic::nodemanager { "${wls_domain}_${::hostname}":
    version                               => $wls_version,
    middleware_home_dir                   => $middleware_home_dir,
    weblogic_home_dir                     => $weblogic_home_dir,
    nodemanager_port                      => $nodemanager_port,
    nodemanager_address                   => $nodemanager_address,
    nodemanager_secure_listener           => true,
    jsse_enabled                          => $jsse_enabled,
    custom_trust                          => $custom_trust,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    custom_identity                       => $custom_identity,
    custom_identity_alias                 => $::hostname,
    custom_identity_keystore_filename     => $custom_identity_keystore_filename,
    custom_identity_keystore_passphrase   => $custom_identity_keystore_passphrase,
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
    tag                                   => $wls_domain,
    require                               => Wls_setting['default'],
  }

  Weblogic::Domain <<| tag == $wls_domain |>>

  #Replaces weblogic::services::startwls
  weblogic::control { "startWLS${adminserver_name}":
    domain_name      => $wls_domain,
    server_type      => 'admin',
    target           => 'Cluster',
    server           => $adminserver_name,
    action           => 'start',
    adminserver_port => $adminserver_port,
    log_output       => $log_output,
    require          => Wls_setting['default'],
  }

  weblogic::packdomain { $wls_domain:
    weblogic_home_dir   => $weblogic_home_dir,
    middleware_home_dir => $middleware_home_dir,
    jdk_home_dir        => $jdk_home_dir,
    wls_domains_dir     => $domains_dir,
    domain_name         => $wls_domain,
    os_user             => $wls_os_user,
    os_group            => $wls_os_group,
    download_dir        => $download_dir,
    require             => [ Weblogic::Domain[$wls_domain], Weblogic::Control["startWLS${adminserver_name}"], ],
  }

  #Replace weblogic::services::userconfig
  #create_resources('weblogic::storeuserconfig',$userconfig_instances, $storeuser_default_params)
  class { 'profile::weblogic::ordering::userconfig':
    userconfig_default_params => {
      require                 => [ Weblogic::Domain[$wls_domain], ],
    },
    userconfig_instances      => $userconfig_instances,
  }
  

  #Replace weblogic::services::security
  #create_resources('wls_user',$user_instances, $security_default_params)
  #create_resources('wls_group',$group_instances, $security_default_params)
  #create_resources('wls_authentication_provider',$authentication_provider_instances, $security_default_params)
  class { 'profile::weblogic::ordering::security':
    security_default_params => {
      require               => Class['profile::weblogic::ordering::userconfig'],
    },
    user_instances              => $user_instances,
    group_instances             => $group_instances,
    authentication_provider     => $authentication_provider,
  }

  class { 'profile::weblogic::ordering::basic_config':
    basic_config_default_params => {
      require                   => Class['profile::weblogic::ordering::security'],
    },
    wls_domain_instances             => $wls_domain_instances,
    wls_adminserver_instances_domain => $wls_adminserver_instances_domain,
    machines_instances               => $machines_instances,
    server_instances                 => $server_instances,
    server_channel_instances         => $server_channel_instances,
    cluster_instances                => $cluster_instances,
    coherence_cluster_instances      => $coherence_cluster_instances,
    server_template_instances        => $server_template_instances,
    mail_session_instances           => $mail_session_instances,
  }
  #include weblogic::services::basic_config
  #  create_resources('wls_domain',$wls_domain_instances, $default_params)

  # subscribe on domain changes
  #  create_resources('wls_adminserver', $wls_adminserver_instances_domain, $default_params)
  #create_resources('wls_machine', $machines_instances, $default_params)
  #create_resources('wls_server', $server_instances, $default_params)
  
  # subscribe on server changes
  #create_resources('wls_server_channel', $server_channel_instances, $default_params)
  #create_resources('wls_cluster', $cluster_instances, $default_params)
#  create_resources('wls_coherence_cluster', $coherence_cluster_instances, $default_params)
#  create_resources('wls_server_template', $server_template_instances, $default_params)
#  create_resources('wls_mail_session', $mail_session_instances, $default_params)

  anchor { 'profile::weblogic::domainadmin::end':
    require => [ Anchor['profile::weblogic::domainadmin::begin'], Weblogic::Packdomain[$wls_domain], ],
  }

  Class['profile::weblogic::base'] ->
  Weblogic::Domain[$wls_domain] ->
  Weblogic::Packdomain[$wls_domain] ->
  Class['profile::weblogic::ordering::userconfig'] ->
  Class['profile::weblogic::ordering::security'] ->
  Class['profile::weblogic::ordering::basic_config'] ->
  Anchor['profile::weblogic::domainadmin::end']
}
