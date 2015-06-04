class profile::weblogic (
  $wls_role   = $profile::weblogic::params,
  $wls_domain = $profile::weblogic::params,
)  inherits profile::weblogic::params {
  case $wls_role {
    'domainadmin': {
      class { 'profile::weblogic::domainadmin':
        wls_domain => $wls_domain,
      }
    }
    'nodemanager': {
      class { 'profile::weblogic::nodemanager':
        wls_domain => $wls_domain,
      }
    }
    'ohs': {
      class { 'profile::weblogic::ohs':
        wls_domain => $wls_domain,
      }
    }
  }
}
