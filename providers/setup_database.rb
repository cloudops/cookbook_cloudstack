# Cookbook Name:: co-cloudstack
# Provider:: init_db
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
#
# Copyright:: Copyright (c) 2014 CloudOps.com
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

include Chef::Mixin::ShellOut


action :create do
  load_current_resource
  #Chef::Log.info "creating cloudstack database"
  unless @current_resource.exists
    # 1. check if database exist, if so create connection config but do not init db.
    # 2. if db not exist, create db and create connection
    if db_exist?
      init_config_database
    else
      init_database
    end
  end
end

#user = "cloud"
#password = "password"
#root_user = "root"
#root_password = "ilikerandompasswords"
#ip = "localhost"
#management_server_key = password
#database_key = password

def load_current_resource
  @current_resource = Chef::Resource::CloudstackSetupDatabase.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.ip(@new_resource.ip)
  @current_resource.user(@new_resource.user)
  @current_resource.password(@new_resource.password)
  @current_resource.root_user(@new_resource.root_user)
  @current_resource.root_password(@new_resource.root_password)
  @current_resource.management_server_key(@new_resource.management_server_key)
  @current_resource.database_key(@new_resource.database_key)
  if dbconf_exist?
    @current_resource.exists = true
  end
end

def script_exist?

end

def init_database
  # Create database in MySQL using cloudstack-setup-databases scripts
  setup_db_init_cmd = "/usr/bin/cloudstack-setup-databases #{@current_resource.user}:#{@current_resource.password}@#{@current_resource.ip} --deploy-as=#{@current_resource.root_user}:#{@current_resource.root_password} -m #{@current_resource.management_server_key} -k #{@current_resource.database_key}"
  cloudstack_setup_database = Mixlib::ShellOut.new(setup_db_init_cmd)
  cloudstack_setup_database.run_command
  if cloudstack_setup_database.exitstatus == 0

  end
end

def init_config_database
  # Create database configuration for cloudstack management server that will use and existing database.
  setup_db_init_cmd = "/usr/bin/cloudstack-setup-databases #{@current_resource.user}:#{@current_resource.password}@#{@current_resource.ip} -m #{@current_resource.management_server_key} -k #{@current_resource.database_key}"
  cloudstack_setup_database = Mixlib::ShellOut.new(setup_db_init_cmd)
  cloudstack_setup_database.run_command
  if cloudstack_setup_database.exitstatus == 0

  end
end

def dbconf_exist?
  # test if db.properties as been modified from default installation file. if password encrypted, then we step there to not break anything.
  Chef::Log.debug "Checking to see if database config db.properties as been configured"
  conf_exist = system("cat /etc/cloudstack/management/db.properties |grep \"ENC(\"")
  #conf_exist return true if file is ready to use.
end

def db_exist?
  # test if database exist and is reachable
  Chef::Log.debug "Checking to see if database cloud exist on: '#{@current_resource.ip}'"
  db_exist = system("mysql -u #{@current_resource.user} -p#{@current_resource.password} -e 'show databases;'|grep cloud")
end

def db_connection_exist?
  Chef::Log.debug "Checking to see if user #{@current_resource.user} can access MySQL server: '#{@current_resource.ip}'"
  user_can_connect = system("mysql -u  #{@current_resource.user} -p #{@current_resource.password} -e 'show databases;'")
end