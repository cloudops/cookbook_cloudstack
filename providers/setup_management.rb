#
# Cookbook Name:: cloudstack
# Provider:: setup_management
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2017, CloudOps, Inc.
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

# use_inline_resources

# # Support whyrun
# def whyrun_supported?
#   false
# end

# action :run do
#   load_current_resource

#   if !@current_resource.exists
#     params = ''
# #    params += ' --tomcat7' if @current_resource.tomcat7
# #    params += ' --https' if @current_resource.https
# #    params += ' --no-start' if @current_resource.nostart

#     bash "cloudstack-setup-management" do
#       code "/usr/bin/cloudstack-setup-management #{params}"
#       not_if { ::File.exists?("/etc/cloudstack/management/tomcat6.conf") || ::File.exists?("/etc/cloudstack/management/server.xml")}
#     end
#   end

# end

# def load_current_resource
#   @current_resource = Chef::Resource::CloudstackSetupDatabase.new(@new_resource.name)
#   @current_resource.name(@new_resource.name)
#   @current_resource.tomcat7(@new_resource.tomcat7)
#   @current_resource.https(@new_resource.https)
#   @current_resource.nostart(@new_resource.nostart)

#   # use tomcat7 if CentOS 7
# #  @current_resource.tomcat = true if node['platform'] == 'centos' && node['platform_version'] == '7'

#   @current_resource.exists = ::File.exists?("/etc/cloudstack/management/server.xml")
# end
