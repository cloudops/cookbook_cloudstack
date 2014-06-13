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

require 'fileutils'
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
  @current_resource.nfs_server(@new_resource.nfs_server)

#  if cloudstack_is_running?
#    @current_resource.exists = true
#  end
end

# Create path
unless Dir.exists?(@current_resource.nfs_path)
  FileUtils.mkdir_p @current_resource.nfs_path
end

# Mount NFS share if required
unless @current_resource.nfs_server == node.name or @current_resource.nfs_server == node["ipaddress"] or @current_resource.nfs_server == "localhost"
  mount @current_resource.nfs_path do
    device "#{@current_resource.nfs_server}:#{@current_resource.nfs_path}"
    fstype "nfs"
    options "rw"
    action [:mount]
  end
end

def download_systemvm_template
  # Create database configuration for cloudstack management server that will use and existing database.
  download_cmd = "/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt  -m #{@current_resource.nfs_path} -u #{@current_resource.url} -h #{@current_resource.hypervisor} -F"
  download_template = Mixlib::ShellOut.new(download_cmd)
  download_template.run_command
  if download_template.exitstatus == 0

  end
end