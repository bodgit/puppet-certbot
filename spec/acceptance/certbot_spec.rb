require 'spec_helper_acceptance'

describe 'certbot' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::epel

      class { '::certbot':
        email   => 'matt@bodgit-n-scarper.com',
        require => Class['::epel'],
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe package('certbot') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/letsencrypt') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe service('certbot-renew.timer'), unless: fact('operatingsystemmajrelease').eql?('6') do
    it { is_expected.to be_enabled }
  end
end
