require 'serverspec'
set :backend, :exec

describe file('/data/secondary') do
  it { should be_directory }
end

describe file('/data/secondary/template/tmpl/1/1') do
  it { should be_directory }
end  

describe file('/data/secondary/template/tmpl/1/1/template.properties') do
  it { should be_file }
  it { should exist }
end  

# describe file('/data/primary') do
#   it { should be_directory }
# end

# describe service('nfs-server') do
#   it { should be_enabled }
#   it { should be_running }
# end
