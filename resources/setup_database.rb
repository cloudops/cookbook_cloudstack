#
# Cookbook Name:: cloudstack
# Resource:: setup_database
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

# include Chef::Mixin::ShellOut

default_action :create

property :ip,                    String, name_property: true
property :user,                  String, default: 'cloud'
property :password,              String, default: 'password'
property :root_user,             String, default: 'root'
property :root_password,         String, default: 'ilikerandompasswords'
property :management_server_key, String, default: 'password'
property :database_key,          String, default: 'password'

action :create do
  unless dbconf_exist?
    @scriptname = '/usr/bin/cloudstack-setup-databases'
    if ::File.exist?(@scriptname) && verify_db_connection?(new_resource.ip, new_resource.root_user, new_resource.root_password)
      if db_exist?(new_resource.ip, new_resource.user, new_resource.password)
        converge_by('Using existing CloudStack database') do
          init_config_database
        end
      else
        converge_by('Creating CloudStack database') do
          init_database
        end
      end
    else
      Chef::Log.error "#{@scriptname} not found or fail to connect to database."
    end
  end
end

action_class do
  include Cloudstack::Helper

  def init_database
    # Create database in MySQL using cloudstack-setup-databases scripts
    setup_db_init_cmd = "#{@scriptname} #{new_resource.user}:#{new_resource.password}@#{new_resource.ip} --deploy-as=#{new_resource.root_user}:#{new_resource.root_password} -m #{new_resource.management_server_key} -k #{new_resource.database_key}"
    shell_out!(setup_db_init_cmd)
  end

  def init_config_database
    # Create database configuration for cloudstack management server that will use and existing database.
    setup_db_init_cmd = "#{@scriptname} #{new_resource.user}:#{new_resource.password}@#{new_resource.ip} -m #{new_resource.management_server_key} -k #{new_resource.database_key}"
    shell_out!(setup_db_init_cmd)
  end

  def dbconf_exist?
    # test if db.properties as been modified from default installation file. if password encrypted, then we step there to not break anything.
    Chef::Log.debug 'Checking to see if database config db.properties as been configured'
    conf_exist = Mixlib::ShellOut.new('cat /etc/cloudstack/management/db.properties |grep "ENC("')
    conf_exist.run_command
    if conf_exist.exitstatus == 0
      true
    else
      Chef::Log.debug 'db.properties does not contain encrypted passwords.'
      false
    end
  end
end
