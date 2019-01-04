#
# Cookbook Name:: cloudstack
# Resource:: global_setting
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
#
# Configure Global Settings
###############################################################################

default_action :update

property :name,                  String, name_property: true
property :value,                 String
property :admin_apikey,          String
property :admin_secretkey,       String

actions :update do
  unless new_resource.admin_apikey.nil?
    unless current_value_exists?
      converge_by("Update Global Setting: #{new_resource.name} to #{new_resource.value}") do
        # test_connection?(new_resource.admin_apikey, new_resource.admin_secretkey)
        update_setting(new_resource.name, new_resource.value)
      end
    end
  end
end

action_class do
  require 'json'
  include Cloudstack::Helper

  def load_current_value(name)
    # get CloudStack current value of the Global Setting
    client = CloudstackRubyClient::Client.new('http://localhost:8080/client/api/', new_resource.admin_apikey, new_resource.admin_secretkey, false)
    client.list_configurations(name: name)['configuration'].first['value']
  end

  def update_setting(name, value)
    client = CloudstackRubyClient::Client.new('http://localhost:8080/client/api/', new_resource.admin_apikey, new_resource.admin_secretkey, false)
    client.update_configuration(
      name: name,
      value: value
    )
  end

  def current_value_exists?
    if cloudstack_is_running?
      if new_resource.admin_apikey.nil? || new_resource.admin_secretkey.nil?
        Chef::Log.error 'admin_apikey empty, cannot update Global Settings'
      else
        current_value = load_current_value(new_resource.name)
        if current_value.nil?
          Chef::Log.error "Global Setting: #{new_resource.name} not found"
        else
          new_resource.value == current_value
        end
      end
    else
      Chef::Log.error 'CloudStack not running, cannot update Global Settings.'
    end
  end
end
