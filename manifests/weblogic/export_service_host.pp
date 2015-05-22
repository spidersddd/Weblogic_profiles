# == Defined Resource Type profile::weblogic::export_service_host
#
# This type will setup an exported host and tag it with 
#  the wls_domain fact.  This will be used on the collector
#  end.  Required param is service and wls_domain.  If it is 
#  not passed it will fail, as it will not be a useful resource.
#
# == Parameters
#
# [*name*]
#  The name of the resouce that is being configured. ie.
#   'admin.puppetlabs.vm'.
#
# [*ipaddress*]
#  IP address for host resolution to additional weblogic services.
#
# [*hostname*]
#  The hostname of the server exporting the resource.
#
# [*service*]
#  The name of the service that is exporting the resource.
#   Currently 'nodemanager' and 'domainadmin' is passed.
#   This will append it to the host entry so the domain
#   can access adminserver with 'domainadmin_grins_domain'
#   as an example.
#
# [*wls_domain*]
#  The wls_domain that the host is assigned to.
define profile::weblogic::export_service_host (
  $ipaddress  = $::ipaddress_eth1,
  $hostname   = $::hostname,
  $service    = undef,
  $wls_domain = $::wls_domain,
) {
  @@host { $name:
    ensure       => present,
    ip           => $ipaddress,
    host_aliases => [$::hostname, "${service}_${wls_domain}"],
    tag          => $wls_domain,
  }
}
