#
# Cookbook Name:: cloudstack
# Provider:: global_setting
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
# Configure Global Settings
###############################################################################

#require 'cloudstack_ruby_client'
require 'json'
include Cloudstack::Helper
include Cloudstack::GlobalSetting

#########
# ACTIONS
#########
action :update do
  unless @current_resource.admin_apikey.nil?
    unless @current_resource.exists
      converge_by("Update Global Setting: #{@current_resource.name} to #{@current_resource.value}") do
        #test_connection?(@current_resource.admin_apikey, @current_resource.admin_secretkey)
        update_setting(@current_resource.name, @current_resource.value)
      end
    end
  end
end



def load_current_resource
  require 'cloudstack_ruby_client'
  @current_resource = Chef::Resource::CloudstackGlobalSetting.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  if $admin_apikey.nil? 
    @current_resource.admin_apikey(@new_resource.admin_apikey)
    @current_resource.admin_secretkey(@new_resource.admin_secretkey)
  else # if it's the first run on the server $admin_apikey will not be empty
    @current_resource.admin_apikey($admin_apikey)
    @current_resource.admin_secretkey($admin_secretkey)
  end
  @current_resource.value(@new_resource.value)

  if cloudstack_is_running?
    if @current_resource.admin_apikey.nil?
      Chef::Log.error "admin_apikey empty, cannot update Global Settings"
    else
      client = CloudstackRubyClient::Client.new("http://localhost:8080/client/api/", @current_resource.admin_apikey, @current_resource.admin_secretkey, false)
      current_value = load_current_value(@current_resource.name)
      if current_value.nil?
        Chef::Log.error "Global Setting: #{@current_resource.name} not found"
      else
        if @current_resource.value == current_value
          @current_resource.exists = true
        else
          @current_resource.exists = false
        end
      end
    end
  else
    Chef::Log.error "CloudStack not running, cannot update Global Settings."
  end
end

