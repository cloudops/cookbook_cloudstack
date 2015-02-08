#
# Cookbook Name:: cloudstack
# Library:: database
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
include Chef::Mixin::ShellOut

module Cloudstack
  module Database

    def init_database
      # Create database in MySQL using cloudstack-setup-databases scripts
      setup_db_init_cmd = "#{@scriptname} #{@current_resource.user}:#{@current_resource.password}@#{@current_resource.ip} --deploy-as=#{@current_resource.root_user}:#{@current_resource.root_password} -m #{@current_resource.management_server_key} -k #{@current_resource.database_key}"
      cloudstack_setup_database = Mixlib::ShellOut.new(setup_db_init_cmd)
      cloudstack_setup_database.run_command
      if cloudstack_setup_database.exitstatus == 0
      end
    end
    
    def init_config_database
      # Create database configuration for cloudstack management server that will use and existing database.
      setup_db_init_cmd = "#{@scriptname} #{@current_resource.user}:#{@current_resource.password}@#{@current_resource.ip} -m #{@current_resource.management_server_key} -k #{@current_resource.database_key}"
      cloudstack_setup_database = Mixlib::ShellOut.new(setup_db_init_cmd)
      cloudstack_setup_database.run_command
      if cloudstack_setup_database.exitstatus == 0
    
      end
    end
    
    def dbconf_exist?
      # test if db.properties as been modified from default installation file. if password encrypted, then we step there to not break anything.
      Chef::Log.debug "Checking to see if database config db.properties as been configured"
      conf_exist = Mixlib::ShellOut.new("cat /etc/cloudstack/management/db.properties |grep \"ENC(\"")
      conf_exist.run_command
      if conf_exist.exitstatus == 0
        return true
      else
        return false
      end
    end

  end
end