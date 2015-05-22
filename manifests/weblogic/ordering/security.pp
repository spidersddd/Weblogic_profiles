class profile::weblogic::ordering::security (
  $security_default_params           = hiera('security_default_params', {}),
  $user_instances                    = hiera('user_instances', {}),
  $group_instances                   = hiera('group_instances', {}),
  $authentication_provider           = hiera('authentication_provider_instances', {}),
) {
  create_resources('wls_user',$user_instances, $security_default_params)
  create_resources('wls_group',$group_instances, $security_default_params)
  create_resources('wls_authentication_provider',$authentication_provider, $security_default_params)
}
