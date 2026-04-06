# @summary Download and install the OnePAM agent binary
# @api private
class onepam::install {
  $arch = $facts['os']['architecture'] ? {
    'x86_64'  => 'amd64',
    'aarch64' => 'arm64',
    default   => fail("Unsupported architecture: ${facts['os']['architecture']}"),
  }

  $binary_url = "${onepam::release_url}/agent/${onepam::agent_version}/onepam-agent-linux-${arch}"

  file { [$onepam::install_dir, "${onepam::install_dir}/bin",
           "${onepam::install_dir}/etc", "${onepam::install_dir}/data"]:
    ensure => directory,
    mode   => '0750',
  }

  exec { 'download-onepam-agent':
    command => "/usr/bin/curl -fsSL -o ${onepam::install_dir}/bin/onepam-agent ${binary_url}",
    creates => "${onepam::install_dir}/bin/onepam-agent",
    require => File["${onepam::install_dir}/bin"],
  }

  file { "${onepam::install_dir}/bin/onepam-agent":
    mode    => '0755',
    require => Exec['download-onepam-agent'],
  }
}
