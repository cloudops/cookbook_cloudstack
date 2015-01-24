 #
# Cookbook Name:: cloudstack
# Library:: system_template
# Author:: Pierre-Luc Dion <pdion@cloudops.com>
# Copyright 2015, CloudOps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
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

module Cloudstack
  module SystemTemplate
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
      unless ::File.exist?(@current_resource.nfs_path)
        directory @current_resource.nfs_path do
          owner "root"
          group "root"
          action :create
          recursive true
        end
      end
    end
    
    def download_systemvm_template
      # Create database configuration for cloudstack management server that will use and existing database.
      #puts "Downloading system template from: #{@current_resource.url}"
      Chef::Log.info "Downloading system template for #{@current_resource.hypervisor}, this will take some time..."
      download_cmd = "/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt  -m #{@current_resource.nfs_path} -u #{@current_resource.url} -h #{@current_resource.hypervisor} -F"
      download_template = Mixlib::ShellOut.new(download_cmd)
      download_template.run_command
      if download_template.exitstatus == 0
      end
    end
  end
end