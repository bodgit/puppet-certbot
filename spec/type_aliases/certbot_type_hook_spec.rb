require 'spec_helper'

describe 'Certbot::Type::Hook' do
  it { is_expected.to allow_values('deploy', 'post', 'pre') }
  it { is_expected.not_to allow_value('invalid') }
end
