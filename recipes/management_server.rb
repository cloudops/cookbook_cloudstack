# Cookbook Name:: cloudstack
# Recipe:: management_server
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2018, CloudOps, Inc.
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
include_recipe 'cloudstack::repo'

package 'cloudstack-management' do
  action :install
  unless node['cloudstack']['version'].empty?
    version node['cloudstack']['version']
  end
end

# tomcat6 package installation automatically start tomcat6 on port 8080.
service 'tomcat6' do
  action [:stop, :disable]
  only_if { platform?(%w(ubuntu debian)) }
end

include_recipe 'cloudstack::vhd-util'

