require 'serverspec'

set :backend, :exec

describe package('cloudstack-management') do
  it { should be_installed }
end


describe user('cloud') do
  it { should exist }
end

