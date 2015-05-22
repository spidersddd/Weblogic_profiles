class profile::weblogic::ordering::basic_config (
  $basic_config_default_params           = hiera('basic_config_default_params'),
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
) {
  create_resources('wls_domain',$wls_domain_instances, $basic_config_default_params)

  # subscribe on domain changes
  create_resources('wls_adminserver', $wls_adminserver_instances_domain, $basic_config_default_params)
  create_resources('wls_machine', $machines_instances, $basic_config_default_params)
  create_resources('wls_server', $server_instances, $basic_config_default_params)

  # subscribe on server changes
  create_resources('wls_server_channel', $server_channel_instances, $basic_config_default_params)
  create_resources('wls_cluster', $cluster_instances, $basic_config_default_params)
  create_resources('wls_coherence_cluster', $coherence_cluster_instances, $basic_config_default_params)
  create_resources('wls_server_template', $server_template_instances, $basic_config_default_params)
  create_resources('wls_mail_session', $mail_session_instances, $basic_config_default_params)

}
