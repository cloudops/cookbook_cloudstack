# Cookbook Name:: cloudstack
# Attribute:: management_server
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
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
####
# Install CloudStack Management Server and perform required tunings.
####
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


# /etc/security
default['cloudstack']['nproc_limit_soft'] = "4096"
default['cloudstack']['nproc_limit_hard'] = "4096"
default['cloudstack']['nproc_limit_file'] = "/etc/security/limits.d/cloudstack_nproc.conf"

default['cloudstack']['nofile_limit_soft'] = "4096"
default['cloudstack']['nofile_limit_hard'] = "4096"
default['cloudstack']['nofile_limit_file'] = "/etc/security/limits.d/cloudstack_nofile.conf"
