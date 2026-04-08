require 'spec_helper'

describe 'onepam::service' do
  let(:pre_condition) do
    "class { 'onepam':
      tenant_id  => 'test-tenant-uuid',
      server_url => 'https://onepam.example.com',
    }"
  end

  context 'with default parameters (present)' do
    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/systemd/system/onepam-agent.service').with(
        ensure: 'file',
        owner: 'root',
        mode: '0644',
      )
    end

    it { is_expected.to contain_exec('onepam-systemd-reload') }

    it do
      is_expected.to contain_service('onepam-agent').with(
        ensure: 'running',
        enable: true,
      )
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
      is_expected.to contain_service('onepam-agent').with(
        ensure: 'stopped',
        enable: false,
      )
    end

    it do
      is_expected.to contain_file('/etc/systemd/system/onepam-agent.service').with(
        ensure: 'absent',
      )
    end
  end
end
