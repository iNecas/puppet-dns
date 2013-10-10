class dns::service {
  service {
    $namedservicename:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
  }
}
