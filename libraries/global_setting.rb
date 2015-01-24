#
# Cookbook Name:: cloudstack
# Library:: global_setting
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
  module GlobalSetting

    # Support whyrun
    def whyrun_supported?
      true
    end
    
    def load_current_value(name)
      require 'cloudstack_ruby_client'
      # get CloudStack current value of the Global Setting
      client = CloudstackRubyClient::Client.new("http://localhost:8080/client/api/", @current_resource.admin_apikey, @current_resource.admin_secretkey, false)
      client.list_configurations(:name => name)["configuration"].first["value"]
    end
    
    def update_setting(name, value)
      require 'cloudstack_ruby_client'
      client = CloudstackRubyClient::Client.new("http://localhost:8080/client/api/", @current_resource.admin_apikey, @current_resource.admin_secretkey, false)
      client.update_configuration({
          :name => name,
          :value => value
      })
    end

  end
end