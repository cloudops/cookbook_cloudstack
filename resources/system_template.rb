#
# Cookbook Name:: cloudstack
# Resource:: system_template
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

default_action :create

property :hypervisor,     String, name_property: true
property :nfs_path,       String, default: '/mnt/secondary'
property :nfs_server,     String, default: 'localhost'

# If URL net specify, can retreive template URL from database.
property :url,            String
property :db_user,        String, default: 'cloud'     # node['cloudstack']['db']['user']
property :db_password,    String, default: 'password'  # node['cloudstack']['db']['password']
property :db_host,        String, default: 'localhost' # node['cloudstack']['db']['host']

action :create do
  load_current_resource

  # Chef::Log.info 'creating cloudstack database'
  unless current_value_exists?
    converge_by("Downloading system template from: #{new_resource.url}") do
      # test_connection?(new_resource.admin_apikey, new_resource.admin_secretkey)
      secondary_storage
      download_systemvm_template
    end
  end
end

action_class do
  include Cloudstack::Helper

  def current_value_exists?
    # if CloudStack management-server is running, it mean a systemvm template as been downloaded.
    if cloudstack_is_running?
      true
    elsif db_exist?(new_resource.db_host, new_resource.db_user, new_resource.db_password)
      if new_resource.url.nil?
        cmd = Mixlib::ShellOut.new("mysql -h #{new_resource.db_host} --user=#{new_resource.db_user} --password='#{new_resource.db_password}' --skip-column-names -U cloud -e 'select max(url) from cloud.vm_template where type = \"SYSTEM\" and hypervisor_type = \"#{new_resource.hypervisor}\" and removed is null'")
        cmd.run_command
        cmd.error!
        new_resource.url(cmd.stdout.chomp)
      end
      template_id = db_template_id
      Chef::Log.debug "looking for template in #{new_resource.nfs_path}/template/tmpl/1/#{template_id}"
      if ::File.exist?("#{new_resource.nfs_path}/template/tmpl/1/#{template_id}/template.properties")
        Chef::Log.debug "template exists in #{new_resource.nfs_path}/template/tmpl/1/#{template_id}"
        true
      else
        false
      end
    else
      Chef::Log.error 'Database not configured. Cannot retrieve Template URL'
    end
  end

  # retrieve template ID from database
  def db_template_id
    # get template ID from database to check path
    Chef::Log.debug 'Retrieve template ID from database'
    template_cmd = "mysql -h #{new_resource.db_host} --user=#{new_resource.db_user} --password=#{new_resource.db_password} --skip-column-names -U cloud -e 'select max(id) from cloud.vm_template where type = \"SYSTEM\" and hypervisor_type = \"#{new_resource.hypervisor}\" and removed is null'"
    template_id = Mixlib::ShellOut.new(template_cmd)
    template_id.run_command
    Chef::Log.debug "template id = #{template_id.stdout.chomp}"
    template_id.stdout.chomp
  end

  # Create or mount secondary storage path
  def secondary_storage
    unless ::File.exist?(new_resource.nfs_path)
      # Use condition enclosing instead of 'not_if' guard because resource nfs_path is not defined in case of resource merging
      directory new_resource.nfs_path do
        owner 'root'
        group 'root'
        action :create
        recursive true
      end
    end
  end

  def download_systemvm_template
    # Create database configuration for cloudstack management server that will use and existing database.
    # puts "Downloading system template from: #{new_resource.url}"
    Chef::Log.info "Downloading system template for #{new_resource.hypervisor}, this will take some time..."
    download_cmd = "/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt  -m #{new_resource.nfs_path} -u #{new_resource.url} -h #{new_resource.hypervisor} -F"
    download_template = Mixlib::ShellOut.new(download_cmd)
    download_template.run_command
    if download_template.exitstatus == 0
    end
  end
end
