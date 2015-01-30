# Cookbook Name:: cloudstack
# Recipe:: management_server
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2015, CloudOps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
####
# Install CloudStack Management Server and perform required tunings.
####

include_recipe 'cloudstack::default'
include_recipe "cloudstack::repo"

package "cloudstack-management" do
   action :install
   if ! node['cloudstack']['version'].empty?
     version node['cloudstack']['version']
   end
end

if platform?(%w{ubuntu debian})
  # tomcat6 package installation automatically start tomcat6 on port 8080.
  service 'tomcat6' do
    action [:stop, :disable]
  end
end


include_recipe "cloudstack::vhd-util"


#
# Set nproc limits for user cloud
#
template node['cloudstack']['nproc_limit_file'] do
  source 'nproc_limits.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user          => node['cloudstack']['username'],
            :hard          => node['cloudstack']['nproc_limit_hard'],
            :soft          => node['cloudstack']['nproc_limit_soft'],
            :recipe_file   => (__FILE__).to_s.split("cookbooks/").last,
            :template_file => source.to_s
end

#
# Set nofile limits for user cloud
#
template node['cloudstack']['nofile_limit_file'] do
  source 'nofile_limits.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user          => node['cloudstack']['username'],
            :hard          => node['cloudstack']['nofile_limit_hard'],
            :soft          => node['cloudstack']['nofile_limit_soft'],
            :recipe_file   => (__FILE__).to_s.split("cookbooks/").last,
            :template_file => source.to_s
end


# Configure sudo for user cloud
include_recipe "sudo"
sudo 'cloud' do
  template 'sudoers_cloudstack.erb'
end



#service "cloudstack-management" do
#  supports :restart => true, :status => true, :start => true, :stop => true
#  action :nothing
#end

