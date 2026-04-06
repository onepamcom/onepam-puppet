# @summary Install and configure the OnePAM agent
#
# @param server_url OnePAM server URL
# @param tenant_id Organisation UUID (required)
# @param group_uuid Optional group assignment
# @param agent_version Agent version to install
# @param log_level Agent log level
# @param release_url Base URL for binary downloads
# @param install_dir Installation directory
# @param ensure Whether the agent should be present or absent
class onepam (
  String              $server_url    = 'https://onepam.com',
  String              $tenant_id     = '',
  String              $group_uuid    = '',
  String              $agent_version = 'latest',
  Enum['debug','info','warn','error'] $log_level = 'info',
  String              $release_url   = 'https://updates.onepam.com',
  String              $install_dir   = '/opt/onepam',
  Enum['present','absent'] $ensure   = 'present',
) {
  if $ensure == 'present' and $tenant_id == '' {
    fail('onepam::tenant_id is required')
  }

  contain onepam::install
  contain onepam::config
  contain onepam::service

  Class['onepam::install']
  -> Class['onepam::config']
  ~> Class['onepam::service']
}
