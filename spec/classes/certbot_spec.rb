require 'spec_helper'

describe 'certbot' do

  let(:params) do
    {
      email: 'test@example.com',
    }
  end

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :os => {
          :family => 'Unsupported',
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{not supported on an Unsupported}) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('certbot::config') }
      it { is_expected.to contain_class('certbot::install') }
      it { is_expected.to contain_class('certbot::params') }
      it { is_expected.to contain_exec('certbot register --agree-tos -m test@example.com') }
      it { is_expected.to contain_file('/etc/letsencrypt') }
      it { is_expected.to contain_file('/etc/letsencrypt/accounts') }
      it { is_expected.to contain_file('/etc/letsencrypt/renewal-hooks') }
      it { is_expected.to contain_file('/etc/letsencrypt/renewal-hooks/deploy') }
      it { is_expected.to contain_file('/etc/letsencrypt/renewal-hooks/post') }
      it { is_expected.to contain_file('/etc/letsencrypt/renewal-hooks/pre') }
      it { is_expected.to contain_package('certbot') }
      it { is_expected.to contain_service('certbot-renew.timer') }
    end
  end
end
