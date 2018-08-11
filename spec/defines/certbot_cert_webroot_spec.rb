require 'spec_helper'

describe 'certbot::cert::webroot' do

  let(:params) do
    {
      domains: {
        '/var/www/html' => [
          'example.com',
          'www.example.com',
        ],
      },
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
        it { is_expected.to contain_certbot__cert('example.com') }
        it { is_expected.to contain_exec('certbot certonly --webroot -w /var/www/html -d example.com -d www.example.com') }
        it { is_expected.to contain_file('/etc/letsencrypt/live/example.com') }
        it { is_expected.to contain_file('/etc/letsencrypt/live/example.com/cert.pem') }
        it { is_expected.to contain_file('/etc/letsencrypt/live/example.com/chain.pem') }
        it { is_expected.to contain_file('/etc/letsencrypt/live/example.com/fullchain.pem') }
        it { is_expected.to contain_file('/etc/letsencrypt/live/example.com/privkey.pem') }
      end
    end
  end
end
