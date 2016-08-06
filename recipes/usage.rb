#
# Cookbook Name:: cloudstack
# Recipe:: usage
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
# install and configure cloudstack-usage service.
# This recipe can be use as is in cookbook wrapper (include_recipe 'cloudstack::usage')
# This service depend on cloudstack-management and MUST run on a management server.

package "cloudstack-usage" do
   action :install
#   only_if { node.recipes.include?('cloudstack::management_server') }
end


service "cloudstack-usage" do
   supports :restart => true, :status => true, :start => true, :stop => true
   action [ :enable, :start ]
   only_if { node['recipes'].include?('cloudstack::management_server') }
end
