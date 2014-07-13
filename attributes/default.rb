#
# Cookbook Name:: cloudstack
# Attribute:: default
#
# Copyright:: Copyright (c) 2014 CloudOps.com
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
    default['cloudstack']['relase_major'] = "4.3"
else
    default['cloudstack']['relase_major'] =  "#{node['cloudstack']['version'].split('.')[0]}.#{node['cloudstack']['version'].split('.')[1]}"
end

# yum repo URL
default['cloudstack']['yum_repo'] = "http://cloudstack.apt-get.eu/rhel/#{node['cloudstack']['relase_major']}/"
# apt repo URL
default['cloudstack']['apt_repo'] = "http://cloudstack.apt-get.eu/ubuntu"


