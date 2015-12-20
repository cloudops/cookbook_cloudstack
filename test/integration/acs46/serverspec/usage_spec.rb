require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('cloudstack-usage') do
  it { should be_installed }
end