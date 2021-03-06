require 'spec_helper'

describe 'cloudstack::management_server' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708').converge(described_recipe)
  end

  it 'installs cloudstack-management' do
    expect(chef_run).to install_package('cloudstack-management')
  end
end
