#
# Cookbook Name:: cloudstack
# Resource:: init_db
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

attribute :ip                   , :name_attribute => true, :kind_of => String
attribute :user                 , :kind_of => String, :default => "cloud"
attribute :password             , :kind_of => String, :default => "password"
attribute :root_user            , :kind_of => String, :default => "root"
attribute :root_password        , :kind_of => String, :default => "ilikerandompasswords"
attribute :management_server_key, :kind_of => String, :default => "password"
attribute :database_key         , :kind_of => String, :default => "password"   

attr_accessor :exists
