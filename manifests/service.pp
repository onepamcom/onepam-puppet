# @summary Manage the OnePAM agent systemd service
# @api private
class onepam::service {
  if $onepam::ensure == 'present' {
    file { '/etc/systemd/system/onepam-agent.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('onepam/onepam-agent.service.epp', {
        install_dir => $onepam::install_dir,
      }),
      notify  => Exec['onepam-systemd-reload'],
    }

    exec { 'onepam-systemd-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
    }

    service { 'onepam-agent':
      ensure    => running,
      enable    => true,
      require   => [File['/etc/systemd/system/onepam-agent.service'], Exec['onepam-systemd-reload']],
      subscribe => File['/etc/systemd/system/onepam-agent.service'],
    }
  } else {
    service { 'onepam-agent':
      ensure => stopped,
      enable => false,
    }

    file { '/etc/systemd/system/onepam-agent.service':
      ensure  => absent,
      require => Service['onepam-agent'],
      notify  => Exec['onepam-systemd-reload-absent'],
    }

    exec { 'onepam-systemd-reload-absent':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
    }
  }
}
