# Changelog

All notable changes to the OnePAM Puppet module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-08

### Added

- Main `onepam` class with install, config, and service management
- Automatic binary download with SHA256 checksum verification
- Systemd service unit management with environment file
- Support for `present`/`absent` lifecycle (clean install and uninstall)
- Architecture detection (amd64/arm64)
- Agent ID generation and persistence
- Configurable parameters: `server_url`, `tenant_id`, `group_uuid`, `agent_version`, `log_level`, `release_url`, `install_dir`
- EPP templates for agent environment and systemd service unit
- Support for Ubuntu 20.04/22.04/24.04, Debian 11/12, RHEL/CentOS/Rocky/Alma 8/9
- Puppet 6.x, 7.x, and 8.x compatibility
- Apache 2.0 license
