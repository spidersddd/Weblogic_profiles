class profile::weblogic::ordering::userconfig (
  $userconfig_instances = hiera('userconfig_instances', {}),
  $userconfig_default_params       = hiera('userconfig_default_params', {}),
) {
  create_resources('weblogic::storeuserconfig',$userconfig_instances, $userconfig_default_params)
}
