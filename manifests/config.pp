# @summary Configure the OnePAM agent
# @api private
class onepam::config {
  if $onepam::ensure == 'present' {
    exec { 'generate-onepam-agent-id':
      command => "/bin/bash -c 'cat /proc/sys/kernel/random/uuid > ${onepam::install_dir}/etc/agent-id && chmod 600 ${onepam::install_dir}/etc/agent-id'",
      creates => "${onepam::install_dir}/etc/agent-id",
    }

    file { "${onepam::install_dir}/etc/agent.env":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => epp('onepam/agent.env.epp', {
        server_url => $onepam::server_url,
        tenant_id  => $onepam::tenant_id,
        log_level  => $onepam::log_level,
        group_uuid => $onepam::group_uuid,
      }),
      require => Exec['generate-onepam-agent-id'],
    }
  } else {
    file { "${onepam::install_dir}/etc/agent.env":
      ensure => absent,
    }

    file { "${onepam::install_dir}/etc/agent-id":
      ensure => absent,
    }
  }
}
