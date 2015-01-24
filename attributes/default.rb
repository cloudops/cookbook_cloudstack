#
# Cookbook Name:: cloudstack
# Attribute:: default
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

# Apache repos:
###############
# version = version of package to install if not define = latest from the repo
default['cloudstack']['version'] = ""
# relase_major = release version, used for the repo URL
if node['cloudstack']['version'].empty?
    default['cloudstack']['release_major'] = "4.4"
else
    default['cloudstack']['release_major'] =  "#{node['cloudstack']['version'].split('.')[0]}.#{node['cloudstack']['version'].split('.')[1]}"
end

# yum repo URL
default['cloudstack']['yum_repo'] = "http://cloudstack.apt-get.eu/rhel/#{node['cloudstack']['release_major']}/"
# apt repo URL
default['cloudstack']['apt_repo'] = "http://cloudstack.apt-get.eu/ubuntu"


# Secondary Storage
default['cloudstack']['secondary']['host'] = node["ipaddress"]
default['cloudstack']['secondary']['path'] = "/data/secondary"
default['cloudstack']['secondary']['mgt_path'] = node['cloudstack']['secondary']['path']


