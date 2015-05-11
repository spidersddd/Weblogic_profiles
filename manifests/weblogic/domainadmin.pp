class profile::weblogic::domainadmin (
	$version = hiera('wls_version'),
	$nodemanager_instances = hiera('nodemanager_instances', {}),
	$middleware_home = hiera('wls_middleware_home_dir'),
	$weblogic_home = hiera('wls_weblogic_home_dir'),
	$os_user = hiera('wls_os_user'),
	$os_group = hiera('wls_os_group'),
	$wls_domain = $::wls_domain,
	$wls_domain_path = hiera('dft_wls_domains_path'),
	$jsse_enabled = hiera('wls_jsse_enabled', false),
	$custom_trust = hiera('wls_custom_trust', false),
	$trust_keystore_file = hiera('wls_trust_keystore_file', undef),
	$trust_keystore_passphrase = hiera('wls_trust_keystore_file', undef),
	$userconfig_instances = hiera('userconfig_instances', {}),
	$user_instances = hiera('user_instances', {}),
	$group_instances = hiera('group_instances', {}),
	$authentication_provider_instances = hiera('authentication_provider_instances', {}),
	$wls_domain_instances = hiera('wls_domain_instances', {}),
	$wls_adminserver_instances_domain = hiera('wls_adminserver_instances_domain', {}),
	$machines_instances = hiera('machines_instances', {}),
	$server_instances = hiera('server_instances'),
	$wls_adminserver_instances_server = hiera('wls_adminserver_instances_server', {}),
	$server_channel_instances = hiera('server_channel_instances', {}),
	$cluster_instances = hiera('cluster_instances', {}),
	$coherence_cluster_instances = hiera('coherence_cluster_instances', {}),
	$server_template_instances = hiera('server_template_instances', {}),
	$mail_session_instances = hiera('mail_session_instances', {}),
	$domains_defaults = {},
	$nodemanager_defaults = {},
	$startwls_defaults = {},
	$userconfig_defaults = {},
	$security_defaults = {},
	$basic_config_defaults = {},
) {


  class { '::weblogic::services::domains':
    default_params        => $domains_defaults,
    file_domain_libs      => hiera('file_domain_libs', {}),
    domain_instances      => hiera('domain_instances', {}),
    wls_setting_instances => hiera('wls_setting_instances', {}),
  }

  class { '::weblogic::services::nodemanager': 
    default_params                => $nodemanager_defaults,
    nodemanager_instances         => $nodemanager_instances,
    version                       => $version,
    wls_weblogic_home_dir         => $weblogic_home,
    wls_os_user                   => $os_user,
    wls_jsse_enabled              => $jsse_enabled,
    wls_custom_trust              => $custom_trust,
    wls_trust_keystore_file       => $trust_keystore_file,
    wls_trust_keystore_passphrase => $trust_keystore_passphrase,
  }

  class { '::weblogic::services::startwls':
    default_params    => $startwls_defaults,
    control_instances => hiera('control_instances', {}),
  }
  
  class { '::weblogic::services::userconfig':
    default_params       => $userconfig_defaults,
    userconfig_instances => $userconfig_instances,
  }

  class { '::weblogic::services::security':
    default_params                    => $security_defaults,
    user_instances                    => $user_instances,
    group_instances                   => $group_instances,
    authentication_provider_instances => $authentication_provider_instances,
  }

  class { '::weblogic::services::basic_config':
    default_params                   => $basic_config_defaults,
    wls_domain_instances             => $wls_domain_instances,
    wls_adminserver_instances_domain => $wls_adminserver_instances_domain,
    machines_instances               => $machines_instances,
    server_instances                 => $server_instances,
    wls_adminserver_instances_server => $wls_adminserver_instances_server,
    server_channel_instances         => $server_channel_instances,
    cluster_instances                => $cluster_instances,
    coherence_cluster_instances      => $coherence_cluster_instances,
    server_template_instances        => $server_template_instances,
    mail_session_instances           => $mail_session_instances,
  }

  Class['orautils'] ->
  Class['weblogic::services::domains'] ->
  Class['weblogic::services::nodemanager'] ->
  Class['weblogic::services::startwls'] # ->
  Class['weblogic::services::userconfig'] ->
  Class['weblogic::services::security'] ->
  Class['weblogic::services::basic_config']
  
}
