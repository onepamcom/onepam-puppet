require 'spec_helper'

describe 'onepam::install' do
  let(:pre_condition) do
    "class { 'onepam':
      tenant_id  => 'test-tenant-uuid',
      server_url => 'https://onepam.example.com',
    }"
  end

  context 'with default parameters (present)' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_package('curl').with_ensure('present') }

    it do
      is_expected.to contain_file('/opt/onepam').with(
        ensure: 'directory',
        owner: 'root',
        mode: '0750',
      )
    end

    it do
      is_expected.to contain_file('/opt/onepam/bin').with(
        ensure: 'directory',
      )
    end

    it { is_expected.to contain_exec('download-onepam-agent') }
    it { is_expected.to contain_exec('verify-onepam-checksum') }

    it do
      is_expected.to contain_file('/opt/onepam/bin/onepam-agent').with(
        owner: 'root',
        mode: '0755',
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
      is_expected.to contain_file('/opt/onepam/bin/onepam-agent').with(
        ensure: 'absent',
      )
    end
  end
end
