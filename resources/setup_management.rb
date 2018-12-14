#
# Cookbook Name:: cloudstack
# Resource:: setup_management
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
# execute default cloudstack configuration script
###############################################################################

property :host,    String,        name_property: true
property :tomcat7, [true, false], required: false, default: true
property :https,   [true, false], required: false, default: false
property :nostart, [true, false], required: false, default: false

action :run do
  new_resource.tomcat7 = true if node['platform'] == 'centos' && node['platform_version'].split('.')[0] == '7'
  params = ''
  params += ' --tomcat7' if new_resource.tomcat7
  params += ' --https'   if new_resource.https
  params += ' --nostart' if new_resource.nostart
  unless ::File.exist?('/etc/cloudstack/management/tomcat6.conf') || ::File.exist?('/etc/cloudstack/management/server.xml')
    converge_by('Configure embedded tomcat') do
      bash 'cloudstack-setup-management' do
        code <<-EOH
          /usr/bin/cloudstack-setup-management #{params}
          if [ ! -f /etc/cloudstack/management/server.xml ]; then
            touch /etc/cloudstack/management/server.xml
          fi
          EOH
      end
    end
  end
end
