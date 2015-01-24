#
# Cookbook Name:: cloudstack
# Provider:: api_keys
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
################################################################################
# Generate api keys for specified CloudStack user.
# currently work for admin account.


require 'uri'
require 'net/http'
require 'json'

include Cloudstack::Helper
include Cloudstack::ApiKeys

# Support whyrun
def whyrun_supported?
  true
end

#########
# ACTIONS
#########

action :create do
  wait_count = 0
  until cloudstack_api_is_running? or wait_count == 5 do
    cloudstack_api_is_running?
    sleep(5)
    wait_count +=1
    if wait_count == 1
      Chef::Log.info "Waiting CloudStack to start"
    end
  end

  create_admin_apikeys
end

action :reset do
  # force generate new API keys
  #load_current_resource
  if cloudstack_is_running?
    if @current_resource.username == "admin"
      converge_by("Reseting admin api keys") do
        admin_keys = generate_admin_keys(@current_resource.url, @current_resource.password)
        Chef::Log.info "admin api keys: Generate new"
        node.normal["cloudstack"]["admin"]["api_key"] = admin_keys[:api_key]
        node.normal["cloudstack"]["admin"]["secret_key"] = admin_keys[:secret_key]
        node.save unless Chef::Config[:solo]
        $admin_apikey = admin_keys[:api_key]
        $admin_secretkey = admin_keys[:secret_key]
      end
    end
  else
    Chef::Log.error "CloudStack not running, cannot generate API keys."
  end
end


def load_current_resource
  @current_resource = Chef::Resource::CloudstackApiKeys.new(@new_resource.name)
  @current_resource.username(@new_resource.name)
  @current_resource.password(@new_resource.password)
  @current_resource.url(@new_resource.url)
  @current_resource.admin_apikey(@new_resource.admin_apikey)
  @current_resource.admin_secretkey(@new_resource.admin_secretkey)
  @current_resource.ssl(@new_resource.ssl)
  
end
