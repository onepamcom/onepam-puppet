# @summary Manage the OnePAM agent systemd service
# @api private
class onepam::service {
  file { '/etc/systemd/system/onepam-agent.service':
    ensure  => file,
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
    ensure => running,
    enable => true,
  }
}
