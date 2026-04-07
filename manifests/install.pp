# @summary Download and install the OnePAM agent binary
# @api private
class onepam::install {
  $arch = $facts['os']['architecture'] ? {
    'x86_64'  => 'amd64',
    'aarch64' => 'arm64',
    default   => fail("Unsupported architecture: ${facts['os']['architecture']}"),
  }

  $binary_url = "${onepam::release_url}/agent/${onepam::agent_version}/onepam-agent-linux-${arch}"
  $checksum_url = "${binary_url}.sha256"
  $version_file = "${onepam::install_dir}/etc/agent-version"

  if $onepam::ensure == 'present' {
    ensure_packages(['curl'], { ensure => present })

    file { [$onepam::install_dir, "${onepam::install_dir}/bin",
             "${onepam::install_dir}/etc", "${onepam::install_dir}/data"]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0750',
    }

    exec { 'download-onepam-agent':
      command => "/usr/bin/curl -fsSL -o ${onepam::install_dir}/bin/onepam-agent ${binary_url}",
      unless  => "/usr/bin/test -f ${version_file} && /usr/bin/test \"$(/bin/cat ${version_file})\" = '${onepam::agent_version}'",
      require => [File["${onepam::install_dir}/bin"], Package['curl']],
    }

    exec { 'verify-onepam-checksum':
      command     => "/bin/bash -c 'cd ${onepam::install_dir}/bin && /usr/bin/curl -fsSL ${checksum_url} | /usr/bin/sha256sum -c -'",
      refreshonly => true,
      subscribe   => Exec['download-onepam-agent'],
    }

    file { $version_file:
      content => $onepam::agent_version,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Exec['verify-onepam-checksum'],
    }

    file { "${onepam::install_dir}/bin/onepam-agent":
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Exec['verify-onepam-checksum'],
    }
  } else {
    file { "${onepam::install_dir}/bin/onepam-agent":
      ensure => absent,
    }

    file { [$onepam::install_dir, "${onepam::install_dir}/bin",
             "${onepam::install_dir}/etc", "${onepam::install_dir}/data"]:
      ensure  => absent,
      recurse => true,
      purge   => true,
      force   => true,
    }
  }
}
