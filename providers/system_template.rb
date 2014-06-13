# Cookbook Name:: cloudstack
# Provider:: system_template
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
# Download system template for initial deployment of CloudStack

include Chef::Mixin::ShellOut


action :create do
  load_current_resource
  #Chef::Log.info "creating cloudstack database"
  unless @current_resource.exists
  end
end

def load_current_resource
  @current_resource = Chef::Resource::CloudstackSystemTemplate.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.hypervisor(@new_resource.hypervisor)
  @current_resource.url(@new_resource.url)
  @current_resource.nfs_path(@new_resource.nfs_path)
#  if cloudstack_is_running?
#    @current_resource.exists = true
#  end
end


# mount NFS share on MGT server if not served from local disk
### mount node["cloudstack"]['secondary']['mgt_path'] do
###   device "#{node["cloudstack"]['secondary']['host']}:#{node["cloudstack"]['secondary']['path']}"
###   fstype "nfs"
###   options "rw"
###   action [:mount]
###   not_if {  node["cloudstack"]['secondary']['host'] == node.name or node["cloudstack"]['secondary']['host'] == node["ipaddress"] }
### end
