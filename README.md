# OnePAM Puppet Module

[![Puppet Forge](https://img.shields.io/puppetforge/v/onepam/onepam.svg)](https://forge.puppet.com/modules/onepam/onepam)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Puppet module for deploying the **OnePAM agent** on Linux servers.

[OnePAM](https://onepam.com) is a unified Zero Trust Privileged Access Management platform.

## Installation

```bash
puppet module install onepam-onepam
```

## Usage

```puppet
class { 'onepam':
  tenant_id  => 'YOUR-TENANT-UUID',
  server_url => 'https://onepam.com',
}
```

### With optional group

```puppet
class { 'onepam':
  tenant_id  => 'YOUR-TENANT-UUID',
  group_uuid => 'YOUR-GROUP-UUID',
  log_level  => 'debug',
}
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `server_url` | String | `https://onepam.com` | OnePAM server URL |
| `tenant_id` | String | — | Organisation UUID (**required**) |
| `group_uuid` | String | `''` | Optional group assignment |
| `agent_version` | String | `latest` | Agent version to install |
| `log_level` | Enum | `info` | Log level (debug, info, warn, error) |
| `release_url` | String | `https://updates.onepam.com` | Binary download base URL |
| `install_dir` | String | `/opt/onepam` | Installation directory |
| `ensure` | Enum | `present` | Use `absent` to uninstall |

## Requirements

- Puppet 6.x, 7.x, or 8.x
- Linux with systemd
- Root access

## Supported Platforms

- Ubuntu 20.04, 22.04, 24.04
- Debian 11, 12
- RHEL / CentOS / Rocky / Alma 8, 9

## Documentation

- [OnePAM Puppet Docs](https://onepam.com/docs/install/puppet)
- [OnePAM Documentation](https://onepam.com/docs)
