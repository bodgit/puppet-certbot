require 'spec_helper'

describe 'Certbot::Type::Plugin' do
  it { is_expected.to allow_values('apache', 'cloudflare', 'cloudxns', 'digitalocean', 'dnsimple', 'dnsmadeeasy', 'gehirn', 'google', 'linode', 'luadns', 'nsone', 'ovh', 'dns-rfc2136', 'route53', 'sakuracloud', 'nginx') }
  it { is_expected.not_to allow_value('invalid') }
end
