require 'spec_helper'

describe 'certbot::hook::post' do

  let(:params) do
    {
      content: 'test',
    }
  end

  let(:title) do
    'test'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without certbot class included' do
        it { is_expected.to compile.and_raise_error(%r{must include the certbot base class}) }
      end

      context 'with certbot class included' do
        let(:pre_condition) do
          'class { "::certbot": email => "test@example.com" }'
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_certbot__hook('post test') }
        it { is_expected.to contain_file('/etc/letsencrypt/renewal-hooks/post/test') }
      end
    end
  end
end
