#
# Cookbook Name:: cloudstack
# Resource:: setup_management
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2017, CloudOps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.require "system_vm_template"

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
#
# execute default cloudstack configuration script
###############################################################################

property :host,    String,        name_property: true
property :tomcat7, [true, false], required: false, default: false
property :https,   [true, false], required: false, default: false
property :nostart, [true, false], required: false, default: false

tomcat7 = true if node['platform'] == 'centos' && node['platform_version'].split('.')[0] == '7'

action :run do
  params = ''
  params += ' --tomcat7' if tomcat7
  params += ' --https'   if https
  params += ' --nostart' if nostart

  bash "cloudstack-setup-management" do
    code "/usr/bin/cloudstack-setup-management #{params}"
    not_if { ::File.exists?("/etc/cloudstack/management/tomcat6.conf") || ::File.exists?("/etc/cloudstack/management/server.xml")}
  end
end
