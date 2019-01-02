#
# Cookbook Name:: test
# Recipe:: all
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2018, CloudOps, Inc.
#
# kitchen test file

include_recipe 'cloudstack::management_server'
include_recipe 'cloudstack::usage'

execute 'set mysql root password' do
  command 'mysqladmin -h 127.0.0.1 -u root password password'
  action :nothing
end

# install mysql-server
package 'mariadb-server'

if platform?(%w(redhat centos fedora oracle))
  service 'mariadb' do
    action :start
    notifies :run, 'execute[set mysql root password]', :immediately
  end
elsif platform?(%w(ubuntu debian))
  service 'mysql' do
    action :start
    notifies :run, 'execute[set mysql root password]', :immediately
  end
end

# init database and connection configuration
cloudstack_setup_database '127.0.0.1' do
  root_user     'root'
  root_password 'password'
  user          'cloud'
  password      'cloud'
  action        :create
end

# download initial systemvm template
cloudstack_system_template 'xenserver' do
  nfs_path    node['cloudstack']['secondary']['path']
  nfs_server  node['cloudstack']['secondary']['host']
  url         node['cloudstack']['systemvm']['xenserver']
  db_user     node['cloudstack']['db']['user']
  db_password node['cloudstack']['db']['password']
  db_host     node['cloudstack']['db']['host']
  action :create
end

cloudstack_setup_management node.name do
  tomcat7 true
end

service 'cloudstack-management' do
  action [ :enable, :start ]
end

service 'cloudstack-usage' do
  action [ :enable, :start ]
end
