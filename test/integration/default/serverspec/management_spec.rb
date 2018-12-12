require 'serverspec'

set :backend, :exec

describe package('cloudstack-management') do
  it { should be_installed }
end

describe user('cloud') do
  it { should exist }
end

describe service('cloudstack-management') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/cloudstack/management/server.xml') do
  it { should be_file }
  it { should exist }
end

describe file('/etc/cloudstack/management/db.properties') do
  it { should be_file }
  it { should exist }
end

describe file('/etc/cloudstack/management/key') do
  it { should be_file }
  it { should exist }
end

describe file('/var/log/cloudstack/management') do
  it { should be_directory }
end

describe command('mysql -u root -h 127.0.0.1 -ppassword -e "show databases;"|grep cloud') do
  its(:exit_status) { should eq 0 }
end
