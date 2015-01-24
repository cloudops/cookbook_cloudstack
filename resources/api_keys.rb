#
# Cookbook Name:: cloudstack
# Resource:: api_keys
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
# Copyright 2015, CloudOps, Inc.
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


actions :create, :reset

default_action :create

attribute :username       , :name_attribute => true, :kind_of => String
attribute :url            , :kind_of => String, :default => "http://localhost:8080/client/api"
attribute :password       , :kind_of => String, :default => "password"
attribute :admin_apikey   , :kind_of => String
attribute :admin_secretkey, :kind_of => String
attribute :ssl 			  , :equal_to => [true, false, 'true', 'false'], :default => false

attr_accessor :exists
