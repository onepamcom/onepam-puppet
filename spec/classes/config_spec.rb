require 'spec_helper'

describe 'onepam::config' do
  let(:pre_condition) do
    "class { 'onepam':
      tenant_id  => 'test-tenant-uuid',
      server_url => 'https://onepam.example.com',
      log_level  => 'debug',
    }"
  end

  context 'with default parameters (present)' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec('generate-onepam-agent-id') }

    it do
      is_expected.to contain_file('/opt/onepam/etc/agent.env').with(
        ensure: 'file',
        owner: 'root',
        mode: '0600',
      )
    end

    it 'renders the environment file with correct values' do
      is_expected.to contain_file('/opt/onepam/etc/agent.env')
        .with_content(%r{AGENT_API_URL="https://onepam\.example\.com"})
    end

    it 'includes the tenant ID' do
      is_expected.to contain_file('/opt/onepam/etc/agent.env')
        .with_content(%r{AGENT_TENANT_ID="test-tenant-uuid"})
    end

    it 'includes the log level' do
      is_expected.to contain_file('/opt/onepam/etc/agent.env')
        .with_content(%r{AGENT_LOG_LEVEL="debug"})
    end
  end

  context 'with group_uuid set' do
    let(:pre_condition) do
      "class { 'onepam':
        tenant_id  => 'test-tenant-uuid',
        server_url => 'https://onepam.example.com',
        group_uuid => 'my-group-uuid',
      }"
    end

    it 'includes AGENT_GROUP_UUID in the environment file' do
      is_expected.to contain_file('/opt/onepam/etc/agent.env')
        .with_content(%r{AGENT_GROUP_UUID="my-group-uuid"})
    end
  end

  context 'with ensure absent' do
    let(:pre_condition) do
      "class { 'onepam':
        tenant_id => 'test',
        ensure    => 'absent',
      }"
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/opt/onepam/etc/agent.env').with(
        ensure: 'absent',
      )
    end

    it do
      is_expected.to contain_file('/opt/onepam/etc/agent-id').with(
        ensure: 'absent',
      )
    end
  end
end
