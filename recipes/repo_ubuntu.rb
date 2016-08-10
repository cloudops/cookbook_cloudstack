#
# Cookbook Name:: cloudstack
# Recipe:: repo_ubuntu
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

include_recipe "apt"

# add Apache CloudStack .deb repo
apt_repository "cloudstack" do
  uri node['cloudstack']['repo_url']
  components [ node['cloudstack']['release_major'] ]
  distribution "trusty"
  trusted node['cloudstack']['repo_trust']
  unless node['cloudstack']['repo_sign'].empty? 
    key node['cloudstack']['repo_sign'] 
  end
  action :add
end


package 'libmysql-java' do
  action :install
  #only_if { node['platform_version'] == "14.04" }
end
