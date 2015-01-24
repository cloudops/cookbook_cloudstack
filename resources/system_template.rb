#
# Cookbook Name:: cloudstack
# Resource:: system_template
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

actions :create

default_action :create

attribute :hypervisor    , :name_attribute => true, :kind_of => String
attribute :nfs_path      , :kind_of => String, :default => "/mnt/secondary"
attribute :nfs_server    , :kind_of => String, :default => "localhost"

# If URL net specify, can retreive template URL from database.
attribute :url           , :kind_of => String
attribute :db_user       , :kind_of => String, :default => 'cloud' #node["cloudstack"]["db"]["user"]
attribute :db_password   , :kind_of => String, :default => 'password' #node["cloudstack"]["db"]["password"]
attribute :db_host       , :kind_of => String, :default => 'localhost' #node["cloudstack"]["db"]["host"]


attr_accessor :exists
