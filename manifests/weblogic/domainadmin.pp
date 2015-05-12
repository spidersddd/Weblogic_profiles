class profile::weblogic::domainadmin (
	$version = hiera('profile::weblogic::version'),
	$nodemanager_instances = hiera('nodemanager_instances', {}),
	$middleware_home = hiera('wls_middleware_home_dir'),
	$weblogic_home = hiera('wls_weblogic_home_dir'),
	$os_user = hiera('wls_os_user'),
	$os_group = hiera('wls_os_group'),
	$wls_domain = $::wls_domain,
	$wls_domain_path = hiera('dft_wls_domains_path'),
	$wls_weblogic_user = hiera('dft_wls_weblogic_user'),
	$domain_wls_password = hiera('dft_domain_wls_password'),
	$adminserver_address = hiera('adminserver_address'),
	$adminserver_port = hiera('adminserver_port',7001),
	$domain_nodemanager_port = hiera('domain_nodemanager_port',5556),
	# java keystores and security
	$jsse_enabled = hiera('wls_jsse_enabled', false),
	$custom_trust = hiera('wls_custom_trust', false),
	$trust_keystore_file = hiera('wls_trust_keystore_file', undef),
	$trust_keystore_passphrase = hiera('wls_trust_keystore_file', undef),
	$trust_alias = hiera('wls_trust_alias', undef),
	$trust_privatekey_passphrase = hiera($wls_trust_privatekey_passphrease, undef),
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
	$grins_domain_adminserver_address = hiera('grins_domain_adminserver_address'),
	$domain_node1_address = hiera('domain_node1_address'),
	$domain_node2_address = hiera('domain_node2_address'),
	$keystore_node1 =    '/vagrant/oracle/identity_node1.jks',
	$keystore_node1_passphrase =  'welcome',
	$keystore_node1_alias =          'node1',
	$keystore_node1_privatekey_passphrase ='welcome',
	$keystore_node2 =   '/vagrant/oracle/identity_node2.jks',
	$keystore_node2_passphrase =   'welcome',
	$keystore_node2_alias =                 'node2',
	$keystore_node2_privatekey_passphrase = 'welcome',
	$domains_defaults = {},
	$nodemanager_defaults = {},
	$startwls_defaults = {},
	$userconfig_defaults = {},
	$security_defaults = {},
	$basic_config_defaults = {},
) {


  #class { '::weblogic::services::domains':
  #  default_params        => $domains_defaults,
  #  file_domain_libs      => hiera('file_domain_libs', {}),
  #  domain_instances      => hiera('domain_instances', {}),
  #  wls_setting_instances => hiera('wls_setting_instances', {}),
  #}
  
  #this is the exploded view of the above - we aren't using create_resources
  #since multiple inheritance issues from yaml make it more complicated that it is worth
  
  weblogic::domain { 'grins_domain':
    domain_name                           => "grins_domain",
    adminserver_name                      => "AdminServer",
    adminserver_address                   => $adminserver_address,
    adminserver_port                      => $adminserver_port,
    nodemanager_port                      => 5556,
    weblogic_password                     => $domain_wls_password,
    domain_template                       => "standard",
    development_mode                      => false,
    log_output                            => $logoutput,
    custom_identity                       => $custom_trust,
    custom_identity_keystore_filename     => $trust_keystore_file,
    custom_identity_keystore_passphrase   => $trust_keystore_passphrase,
    custom_identity_alias                 => $trust_alias,
    custom_identity_privatekey_passphrase => $trust_privatekey_passphrease,
  }
  
  #files needed for this setup
  # which is none
  
  # wls_setting_instances 
  wls_setting_instances { 'default':
    user              => $os_user,
    weblogic_home_dir => $weblogic_home,
    connect_url       => "t3://${adminserver_address}:${adminserver_port}",
    weblogic_user     => $wls_weblogic_user,
    weblogic_password => $domain_wls_password,
  }
  

  #class { '::weblogic::services::nodemanager': 
  #  default_params                => $nodemanager_defaults,
  #  nodemanager_instances         => $nodemanager_instances,
  #  version                       => $version,
  #  wls_weblogic_home_dir         => $weblogic_home,
  #  wls_os_user                   => $os_user,
  #  wls_jsse_enabled              => $jsse_enabled,
  #  wls_custom_trust              => $custom_trust,
  #  wls_trust_keystore_file       => $trust_keystore_file,
  #  wls_trust_keystore_passphrase => $trust_keystore_passphrase,
  #}
  
  weblogic::nodemanager { 'nodemanager':
    log_output                            => true,
    custom_identity                       => $custom_trust,
    custom_identity_keystore_filename     => $trust_keystore_file,
    custom_identity_keystore_passphrase   => $trust_keystore_passphrase,
    custom_identity_alias                 => $trust_alias,
    custom_identity_privatekey_passphrase => $trust_privatekey_passphrease,
    nodemanager_address                   => $adminserver_address,
  }
  
  orautils::nodemanagerautostart{"autostart weblogic ${version}":
    version                 => "${version}",
    wlHome                  => $weblogic_home,
    user                    => $os_user,
    jsseEnabled             => $jsse_enabled,
    customTrust             => $custom_trust,
    trustKeystoreFile       => $trust_keystore_file,
    trustKeystorePassphrase => $trust_keystore_passphrase,
  }

  #class { '::weblogic::services::startwls':
   # default_params    => $startwls_defaults,
  #  control_instances => hiera('control_instances', {}),
  #}
  
  weblogic::control { 'startWLSAdminServer':
  	domain_name      => 'grins_domain',
  	server_type      => 'admin',
  	target           => 'Cluster',
  	server           => 'AdminServer',
  	action           => 'start',
  	adminserver_port => $adminserver_port,
  	log_output       => true,
  }
  
  #class { '::weblogic::services::userconfig':
  #  default_params       => $userconfig_defaults,
  #  userconfig_instances => $userconfig_instances,
  #}

	# no userconfigs

  #class { '::weblogic::services::security':
  #  default_params                    => $security_defaults,
  #  user_instances                    => $user_instances,
  #  group_instances                   => $group_instances,
  #  authentication_provider_instances => $authentication_provider_instances,
  #}
  
  wls_user { ['testuser1','testuser3','testuser2']:
    ensure                 => 'present',
    password               => 'weblogic1',
    authenticationprovider => 'DefaultAuthenticator',
    realm                  => 'myrealm',
    description            => 'my test user',
  }
  
  wls_group { 'TestGroup': 
  	ensure                 => 'present',
    authenticationprovider => 'DefaultAuthenticator',
    description            => 'My TestGroup',
    realm                  => 'myrealm',
    users                  => ['testuser1','testuser2'],
    require                => Wls_user['testuser1','testuser2'],
  }
  
  wls_group { 'SuperUsers':
    ensure                 => 'present',
    authenticationprovider => 'DefaultAuthenticator',
    description            => 'SuperUsers',
    realm                  => 'myrealm',
    users                  => ['testuser2'],
    require                => Wls_user['testuser2'],
  }
  
  #class { '::weblogic::services::basic_config':
  #  default_params                   => $basic_config_defaults,
  #  wls_domain_instances             => $wls_domain_instances,
  #  wls_adminserver_instances_domain => $wls_adminserver_instances_domain,
  #  machines_instances               => $machines_instances,
  #  server_instances                 => $server_instances,
  #  wls_adminserver_instances_server => $wls_adminserver_instances_server,
  #  server_channel_instances         => $server_channel_instances,
  #  cluster_instances                => $cluster_instances,
  #  coherence_cluster_instances      => $coherence_cluster_instances,
  #  server_template_instances        => $server_template_instances,
  #  mail_session_instances           => $mail_session_instances,
  #}

  wls_domain { 'grins_domain':
    ensure                      => 'present',
    jpa_default_provider        => 'org.eclipse.persistence.jpa.PersistenceProvider',
    jta_max_transactions        => '20000',
    jta_transaction_timeout     => '35',
    log_file_min_size           => '5000',
    log_filecount               => '10',
    log_filename                => '/var/log/weblogic/grins_domain.log',
    log_number_of_files_limited => '1',
    log_rotate_logon_startup    => '1',
    log_rotationtype            => 'bySize',
    security_crossdomain        => '0',
  }
  wls_adminserver {   'AdminServer_grins_domain':
    ensure                    => 'running',
    server_name               => $adminserver_address,
    domain_name               => 'grins_domain',
    domain_path               => $wls_domains_path,
    os_user                   => $os_user,
    weblogic_home_dir         => $weblogic_home_dir,
    weblogic_user             => $weblogic_user,
    weblogic_password         => $domain_wls_password,
    jdk_home_dir              => '/usr/java/latest',
    nodemanager_address       => $grins_domain_adminserver_address,
    nodemanager_port          => $domain_nodemanager_port,
    jsse_enabled              => $jsse_enabled,
    custom_trust              => $custom_trust,
    trust_keystore_file       => $trust_keystore_file,
    trust_keystore_passphrase => $trust_keystore_passphrase,
    refreshonly               => true,
    subscribe                 => Wls_domain['grins_domain'],
  }
  wls_machine { 'LocalMachine':
    ensure        => 'present',
    listenaddress => $grins_domain_adminserver_address,
    listenport    => $domain_nodemanager_port,
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
  }
	# in the future this may be easier to do with exported resources
	# or puppetdbquery - we don't need to statically set worker nodes then
	wls_machine { 'Node1':
    ensure        => 'present',
    listenaddress => $domain_node1_address,
    listenport    => $domain_nodemanager_port,
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
  }
  wls_machine { 'Node2':
    ensure        => 'present',
    listenaddress => $domain_node2_address,
    listenport    => $domain_nodemanager_port,
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
  }
  
  #defaults for wls_server
  Wls_server {
    listenport                     => $adminserver_port,
    log_file_min_size              => '2000',
    log_filecount                  => '10',
    log_number_of_files_limited    => '1',
    log_rotate_logon_startup       => '1',
    log_rotationtype               => 'bySize',
    sslhostnameverificationignored => '1',
    two_way_ssl                    => '0',
    client_certificate_enforced    => '0',
    jsseenabled                    => '1',
    custom_identity                => '1',
  }
  
  wls_server {   'AdminServer':
    ensure    => 'present',
    arguments => [
      '*server_vm_args_permsize',
      '*server_vm_args_max_permsize',
      '*server_vm_args_memory',
      '*server_vm_args_max_memory',
      '-Dweblogic.Stdout=/var/log/weblogic/AdminServer.out',
      '-Dweblogic.Stderr=/var/log/weblogic/AdminServer_err.out'
    ],
    listenaddress                         => $grins_domain_adminserver_address,
    machine                               => 'LocalMachine',
    logfilename                           => '/var/log/weblogic/AdminServer.log',
    log_datasource_filename               => '/var/log/weblogic/AdminServer_datasource.log',
    log_http_filename                     => '/var/log/weblogic/AdminServer_access.log',
    log_http_format_type                  => 'extended',
    log_http_format                       => 'date time x-XForwardedFor s-ip cs-method cs-uri x-SOAPAction sc-status bytes time-taken x-UserAgent',
    tunnelingenabled                      => '0',
    max_message_size                      => '10000000',
    sslenabled                            => '0',
    ssllistenport                         => '7002',
    custom_identity_keystore_filename     => $trust_keystore_file,
    custom_identity_keystore_passphrase   => $trust_keystore_passphrase,
    custom_identity_alias                 => $trust_alias,
    custom_identity_privatekey_passphrase => $trust_privatekey_passphrase,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    require                               => Wls_machine['LocalMachine'],
  }

  wls_server {   'grins_ws_1':
    ensure    => 'present',
    arguments => [
      '*server_vm_args_permsize',
      '*server_vm_args_max_permsize',
      '*server_vm_args_memory',
      '*server_vm_args_max_memory',
      '-Dweblogic.Stdout=/var/log/weblogic/grins_ws_1.out',
      '-Dweblogic.Stderr=/var/log/weblogic/grins_ws_1_err.out'
    ],
    listenaddress                         => $domain_node1_address,
    listenport                            => '7003',
    logfilename                           => '/var/log/weblogic/grins_ws_1.log',
    log_datasource_filename               => '/var/log/weblogic/grins_ws_1_datasource.log',
    log_http_filename                     => '/var/log/weblogic/grins_ws_1_access.log',
    machine                               => 'Node1',
    sslenabled                            => '1',
    ssllistenport                         => '8201',
    custom_identity_keystore_filename     => $keystore_node1,
    custom_identity_keystore_passphrase   => $keystore_node1_passphrase,
    custom_identity_alias                 => $keystore_node1_alias,
    custom_identity_privatekey_passphrase => $keystore_node1_privatekey_passphrase,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    max_message_size                      => '25000000',
    require                               => Wls_machine['Node1'],
  }
  wls_server {   'grins_ws_2':
    ensure    => 'present',
    arguments => [
      '*server_vm_args_permsize',
      '*server_vm_args_max_permsize',
      '*server_vm_args_memory',
      '*server_vm_args_max_memory',
      '-Dweblogic.Stdout=/var/log/weblogic/grins_ws_2.out',
      '-Dweblogic.Stderr=/var/log/weblogic/grins_ws_2_err.out'
    ],
    listenaddress                         => $domain_node2_address,
    listenport                            => '7003',
    logfilename                           => '/var/log/weblogic/grins_ws_2.log',
    log_datasource_filename               => '/var/log/weblogic/grins_ws_2_datasource.log',
    log_http_filename                     => '/var/log/weblogic/grins_ws_2_access.log',
    machine                               => 'Node2',
    sslenabled                            => '1',
    ssllistenport                         => '8201',
    custom_identity_keystore_filename     => $keystore_node2,
    custom_identity_keystore_passphrase   => $keystore_node2_passphrase,
    custom_identity_alias                 => $keystore_node2_alias,
    custom_identity_privatekey_passphrase => $keystore_node2_privatekey_passphrase,
    trust_keystore_file                   => $trust_keystore_file,
    trust_keystore_passphrase             => $trust_keystore_passphrase,
    max_message_size                      => '25000000',
    require                               => Wls_machine['Node2'],
  }
  
  wls_adminserver { 'AdminServer_grins_domain_2':
    ensure                    => 'running',
    server_name               => $domain_adminserver,
    domain_name               => $domain_name,
    domain_path               => "%{hiera('wls_oracle_base_home_dir')}/user_projects/domains/grins_domain",
    os_user                   => $os_user,
    weblogic_home_dir         => $weblogic_home_dir,
    weblogic_user             => $weblogic_user,
    weblogic_password         => $domain_wls_password,
    jdk_home_dir              => '/usr/java/latest',
    nodemanager_address       => $grins_domain_adminserver_address,
    nodemanager_port          => $domain_nodemanager_port,
    jsse_enabled              => $jsse_enabled,
    custom_trust              => $custom_trust,
    trust_keystore_file       => $trust_keystore_file,
    trust_keystore_passphrase => $trust_keystore_passphrase,
    refreshonly               => true,
    subscribe                 => Wls_server[AdminServer],
  }
  
  Wls_server_channel { 
    ensure           => present,
    enabled          => '1',
    outboundenabled  => '0',
    tunnelingenabled => '0',
  }
  
  wls_server_channel { 'grins_ws_1:Channel-Cluster':
    httpenabled   => '1',
    listenaddress => $domain_node1_address,
    listenport    => '8003',
    protocol      => 'cluster-broadcast',
    publicaddress => $domain_node1_address,
    require       => Wls_server['grins_ws_1'],
  }
  wls_server_channel { 'grins_ws_2:Channel-Cluster':
    httpenabled   => '1',
    listenaddress => $domain_node2_address,
    listenport    => '8003',
    protocol      => 'cluster-broadcast',
    publicaddress => $domain_node2_address,
    require       => Wls_server['grins_ws_2'],
  }
  wls_server_channel { 'grins_ws_1:HTTP':
    httpenabled      => '1',
    listenport       => '8004',
    publicport       => '8104',
    protocol         => 'http',
    max_message_size => '35000000',
    require          => Wls_server['grins_ws_1'],
  }
  wls_server_channel { 'grins_ws_2:HTTP':
    httpenabled      => '1',
    listenport       => '8004',
    publicport       => '8104',
    protocol         => 'http',
    max_message_size => '35000000',
    require          => Wls_server['grins_ws_2'],
  }
  
  wls_cluster { 'WebCluster':
    ensure                  => 'present',
    migrationbasis          => 'consensus',
    servers                 => ['grins_ws_1', 'grins_ws_2'],
    messagingmode           => 'unicast',
    unicastbroadcastchannel => 'Channel-Cluster',
    frontendhost            => $grins_domain_adminserver_address,
    frontendhttpport        => '2001',
    frontendhttpsport       => '2002',
    require                 => Wls_server['grins_ws_1','grins_ws_2'],
  }
  
 wls_mail_sessions { 'myMailSession':
    ensure       => present,
    jndiname     => 'myMailSession',
    target       => ['WebCluster'],
    targettype   => ['Cluster'],
    mailproperty => [
     'mail.host=smtp.hostname.com',
     'mail.user=smtpadmin'
    ],
    require => Wls_cluster['WebCluster'],
  }
  
  
  Class['orautils'] ->
  Class['weblogic::services::domains'] ->
  Class['weblogic::services::nodemanager'] ->
  Class['weblogic::services::startwls'] # ->
  Class['weblogic::services::userconfig'] ->
  Class['weblogic::services::security'] ->
  Class['weblogic::services::basic_config']
  
}
