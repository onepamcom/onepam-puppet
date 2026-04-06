# @summary Configure the OnePAM agent
# @api private
class onepam::config {
  exec { 'generate-onepam-agent-id':
    command => "/bin/bash -c 'cat /proc/sys/kernel/random/uuid > ${onepam::install_dir}/etc/agent-id'",
    creates => "${onepam::install_dir}/etc/agent-id",
  }

  file { "${onepam::install_dir}/etc/agent.env":
    ensure  => file,
    mode    => '0600',
    content => epp('onepam/agent.env.epp', {
      server_url => $onepam::server_url,
      tenant_id  => $onepam::tenant_id,
      log_level  => $onepam::log_level,
      group_uuid => $onepam::group_uuid,
      install_dir => $onepam::install_dir,
    }),
    require => Exec['generate-onepam-agent-id'],
  }
}
