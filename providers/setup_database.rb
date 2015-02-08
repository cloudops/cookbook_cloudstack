#
# Cookbook Name:: cloudstack
# Provider:: setup_database
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

#include Chef::Mixin::ShellOut
include Cloudstack::Helper
include Cloudstack::Database

action :create do
  #load_current_resource
  #Chef::Log.info "creating cloudstack database"
  unless @current_resource.exists
    # 1. check if database exist, if so create connection config but do not init db.
    # 2. if db not exist, create db and create connection
    @scriptname = "/usr/bin/cloudstack-setup-databases"
    if ::File.exist?(@scriptname)
      if db_exist?(@current_resource.ip, @current_resource.user, @current_resource.password)
        converge_by("Using existing CloudStack database") do
          init_config_database
        end
      else
        converge_by("Creating CloudStack database") do
          init_database
        end
      end
    else
      Chef::Log.error "#{@scriptname} not found"
    end
  end
end

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
  
  if cloudstack_is_running?
    @current_resource.exists = true
  else
    if dbconf_exist?
      if db_exist?(@current_resource.ip, @current_resource.user, @current_resource.password)
        @current_resource.exists = true
      else
        Chef::Log.info "Database server ready, not database found, creating it..."
        @current_resource.exists = false
      end
    else
      @current_resource.exists = false
    end
  end
end
