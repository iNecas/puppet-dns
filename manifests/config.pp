class dns::config {
  group { $dns::params::group: }

  concat_build { 'dns_zones':
    order  => ['*.dns'],
  }

  concat_fragment { 'dns_zones+01-header.dns':
    content => ' ',
  }

  file {
    $dns::namedconf_path:
      owner   => root,
      group   => $dns::params::group,
      mode    => '0640',
      notify  => Service[$namedservicename],
      content => template('dns/named.conf.erb');
    $dns::publicviewpath:
      owner   => root,
      group   => $dns::params::group,
      mode    => '0640',
      require => Concat_build['dns_zones'],
      notify  => Service[$namedservicename],
      source  => concat_output('dns_zones');
    $dns::optionspath:
      owner   => root,
      group   => $dns::params::group,
      mode    => '0640',
      notify  => Service[$namedservicename],
      content => template('dns/options.conf.erb');
    $dns::zonefilepath:
      ensure  => directory,
      owner   => $dns::params::user,
      group   => $dns::params::group,
      mode    => '0640';
    "${dns::vardir}/puppetstore":
      ensure  => directory,
      group   => $dns::params::group,
      mode    => '0640';
  }

  exec { 'create-rndc.key':
    command => "/usr/sbin/rndc-confgen -r /dev/urandom -a -c ${rndckeypath}",
  } ->
  file { $rndckeypath:
    owner   => 'root',
    group   => $dns::params::group,
    mode    => '0640',
  }

}

