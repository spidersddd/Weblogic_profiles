class profile::weblogic::java {

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  }

  anchor { 'profile::weblogic::java::begin': }
  -> 
  class { 'jdk7': }
  -> 
  jdk7::install7 { 'jdk1.7.0_76':
    version                   => "7u76" ,
    fullVersion               => "jdk1.7.0_76",
    alternativesPriority      => 18000,
    x64                       => true,
    downloadDir               => "/tmp/oracle",
    urandomJavaFix            => false,
    rsakeySizeFix             => true,
    cryptographyExtensionFile => "UnlimitedJCEPolicyJDK7.zip",
    sourcePath                => "/vagrant/oracle",
  }
  ->
  anchor { 'profiles::weblogic::java::begin': }
}

