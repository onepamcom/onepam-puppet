require 'spec_helper'

describe 'onepam' do
  let(:params) do
    {
      tenant_id: 'test-tenant-uuid',
      server_url: 'https://onepam.example.com',
    }
  end

  context 'on Linux with present' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('onepam::install') }
    it { is_expected.to contain_class('onepam::config') }
    it { is_expected.to contain_class('onepam::service') }
  end

  context 'when ensure is absent' do
    let(:params) { super().merge(ensure: 'absent') }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('onepam::install') }
    it { is_expected.to contain_class('onepam::config') }
    it { is_expected.to contain_class('onepam::service') }
  end

  context 'when tenant_id is missing and ensure is present' do
    let(:params) { { tenant_id: '' } }

    it { is_expected.to compile.and_raise_error(%r{onepam::tenant_id is required}) }
  end

  context 'on non-Linux' do
    let(:facts) { super().merge(kernel: 'Windows') }

    it { is_expected.to compile.and_raise_error(%r{only supports Linux}) }
  end
end
