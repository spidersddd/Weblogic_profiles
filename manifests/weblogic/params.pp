class profile::weblogic::params {

  $wls_domain                            = "${::wls_domain}"
  $jdk_home_dir                          = hiera('profile::weblogic::jdk_home_dir', '/usr/java/latest')
  $download_dir                          = hiera('download_dir', '/tmp/oracle')
  $fmw_plugins                           = hiera_hash('profile::weblogic::base::addons', {})
  $opatch                                = hiera_hash('profile::weblogic::base::opatch', {})
  $wls_version                           = hiera('wls_version', 1036)
  $wls_os_user                           = hiera('wls_os_user', 'webadmin')
  $wls_os_group                          = hiera('wls_os_group', 'webadmns')
  $wls_weblogic_user                     = 'weblogic'
  $wls_weblogic_password                 = 'weblogic1'
  $wls_oracle_base_home_dir              = '/opt/was/oracle'
  $wls_middleware_home_dir               = hiera('wls_middleware_home_dir', "${wls_oracle_base_home_dir}/middleware/${wls_version}")
  $wls_weblogic_home_dir                 = hiera('wls_weblogic_home_dir', "${wls_middleware_home_dir}/wlserver")
  $wls_domains_path                      = hiera('domains_dir', "${wls_middleware_home_dir}/user_projects/domains")
  $apps_dir                              = hiera('wls_apps_dir', "${wls_middleware_home_dir}/user_projects/applications")
  $wls_log_output                        = hiera('log_outpu', true)
  $wls_log_dir                           = '/opt/log/weblogic'
  $adminserver_name                      = hiera('adminserver_name', 'AdminServer')
  $development_mode                      = hiera('wls_development_mode', true)
  $adminserver_address                   = hiera('adminserver_address')
  $adminserver_port                      = hiera('adminserver_port', '7001')
  $java_arguments                        = hiera('wls_java_arguments', {})
  $jsse_enabled                          = hiera('wls_jsse_enabled', true)
  $nodemanager_address                   = $::ipaddress_eth1
  $nodemanager_port                      = hiera('nodemanager_port', '5556')
  $weblogic_user                         = hiera('wls_weblogic_user', 'weblogic')
  $webtier_enabled                       = 'true'
  $custom_trust                          = hiera('wls_custom_trust', false)
  $trust_keystore_file                   = hiera('wls_trust_keystore_file'       , undef)
  $trust_keystore_passphrase             = hiera('wls_trust_keystore_passphrase' , undef)
  $custom_identity                       = hiera('custom_identity', false)
  $custom_identity_keystore_filename     = "${source}/identity_${::hostname}.jks"
  $custom_identity_keystore_passphrase   = hiera('custom_identity_keystore_passphrase', 'welcome')
  $custom_identity_alias                 = "${::hostname}"
  $custom_identity_privatekey_passphrase = hiera('custom_identity_privatekey_passphrase', 'welcome')
  $create_rcu                            = hiera('create_rcu', false)
  $user_config_file                      = hiera('domain_user_config_file', "/home/webadmin/wls-Wls1036-WebLogicConfig.properties")
  $user_key_file                         = hiera('domain_user_key_file', "/home/webadmin/wls-Wls1036-WebLogicKey.properties")

  case $::osfamily {
    'RedHat': {
      $wls_filename             = hiera('wls_filename', 'wls1036_generic.jar')
      $source                   = hiera('source', '/vagrant/oracle')
    }
    'AIX': {
      $wls_filename             = hiera('wls_filename', 'wls1036_generic.jar')
      $source                   = hiera('source', '/vagrant/oracle')
    }
    default: {
      fail "Operating System family ${::osfamily} not supported"
    }
  }
  case $::lfg_sysrole { 
    'wlsmgr': {
      $wls_role = hiera('wls_role', 'domainadmin')
    }
    'wls': {
      $wls_role = hiera('wls_role', 'nodemanager')
    }
    'ohs': {
      $wls_role = hiera('wls_role', 'ohs')
    }
    'all': {
      $wls_role = hiera('wls_role', 'allin1')
    }
    default: {
      fail "lfg_sysrole is not set correctly, possible values are [wlsmgr, wls, ohs, all], $::lfg_sysrole"
    }
  }
}

