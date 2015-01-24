#
# Cookbook Name:: cloudstack
# Provider:: system_template
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
# Download system template for initial deployment of CloudStack

include Chef::Mixin::ShellOut
include Cloudstack::Helper
include Cloudstack::SystemTemplate

action :create do
  load_current_resource

  #Chef::Log.info "creating cloudstack database"
  unless @current_resource.exists
    converge_by("Downloading system template from: #{@current_resource.url}") do
      #test_connection?(@current_resource.admin_apikey, @current_resource.admin_secretkey)
      secondary_storage
      download_systemvm_template
    end
  end
end


def load_current_resource
  @current_resource = Chef::Resource::CloudstackSystemTemplate.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.url(@new_resource.url)  
  @current_resource.hypervisor(@new_resource.hypervisor)
  @current_resource.nfs_path(@new_resource.nfs_path)
  @current_resource.nfs_server(@new_resource.nfs_server)
  @current_resource.db_user(@new_resource.db_user)
  @current_resource.db_password(@new_resource.db_password)
  @current_resource.db_host(@new_resource.db_host)

  # if CloudStack management-server is running, it mean a systemvm template as been downloaded.
  if cloudstack_is_running?
    @current_resource.exists = true
  else
    if db_exist?(@current_resource.db_host, @current_resource.db_user, @current_resource.db_password)
      if @current_resource.url.nil?
        @current_resource.url(`mysql -h #{@current_resource.db_host} --user=#{@current_resource.db_user} --password=#{@current_resource.db_password} --skip-column-names -U cloud -e 'select max(url) from cloud.vm_template where type = \"SYSTEM\" and hypervisor_type = \"#{@current_resource.hypervisor}\" and removed is null'`.chomp)
      end
      template_id = get_template_id
      Chef::Log.debug "looking for template in #{@current_resource.nfs_path}/template/tmpl/1/#{template_id}"
      if ::File.exist?("#{@current_resource.nfs_path}/template/tmpl/1/#{template_id}/template.properties")
        Chef::Log.debug "template exists in #{@current_resource.nfs_path}/template/tmpl/1/#{template_id}"
        @current_resource.exists = true
      else
        @current_resource.exists = false
      end
    else
      Chef::Log.error "Database not configured. Cannot retrieve Template URL"
    end
  end

end

