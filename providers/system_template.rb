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
include Cloudstack

action :create do
  load_current_resource

  #Chef::Log.info "creating cloudstack database"
  unless @current_resource.exists
    secondary_storage
    download_systemvm_template
  end
end


def load_current_resource
  @current_resource = Chef::Resource::CloudstackSystemTemplate.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
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
    if @new_resource.url.nil?
      if db_exist?(@current_resource.db_host, @current_resource.db_user, @current_resource.db_password)
        @current_resource.url(`mysql -h #{@current_resource.db_host} --user=#{@current_resource.db_user} --password=#{@current_resource.db_password} --skip-column-names -U cloud -e 'select max(url) from cloud.vm_template where type = \"SYSTEM\" and hypervisor_type = \"#{@current_resource.hypervisor}\" and removed is null'`.chomp)
        template_id = get_template_id
        if ::File.exist?("#{@current_resource.nfs_path}/template/tmpl/1/#{template_id}/template.properties")
          @current_resource.exists = true
        end
      else
        Chef::Log.error "Database not configured. Cannot retrieve Template URL"
      end
    else
      @current_resource.url(@new_resource.url)
    end
  
  end

end

# retrieve template ID from database
def get_template_id
  # get template ID from database to check path
  Chef::Log.debug "Retrieve template ID from database"
  template_cmd = "mysql -h #{@current_resource.db_host} --user=#{@current_resource.db_user} --password=#{@current_resource.db_password} --skip-column-names -U cloud -e 'select max(id) from cloud.vm_template where type = \"SYSTEM\" and hypervisor_type = \"#{@current_resource.hypervisor}\" and removed is null'"
  template_id = Mixlib::ShellOut.new(template_cmd)
  template_id.run_command
  Chef::Log.debug "template id = #{template_id.stdout.chomp}"
  return template_id.stdout.chomp
end


# Create or mount secondary storage path
def secondary_storage
  directory @current_resource.nfs_path do
    owner "root"
    group "root"
    action :create
    recursive true
  end

  # Mount NFS share if required
#  unless @current_resource.nfs_server == node.name or @current_resource.nfs_server == node["ipaddress"] or @current_resource.nfs_server == "localhost"
#    mount @current_resource.nfs_path do
#      device "#{@current_resource.nfs_server}:#{@current_resource.nfs_path}"
#      fstype "nfs"
#      options "rw"
#      action [:mount]
#    end
#  end
end

def download_systemvm_template
    # Create database configuration for cloudstack management server that will use and existing database.
    Chef::Log.info "Downloading system template for #{@current_resource.hypervisor}, this will take some time..."
    download_cmd = "/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt  -m #{@current_resource.nfs_path} -u #{@current_resource.url} -h #{@current_resource.hypervisor} -F"
    download_template = Mixlib::ShellOut.new(download_cmd)
    download_template.run_command
    if download_template.exitstatus == 0
  end
end