#
# Cookbook Name:: marvin
# resource:: configure cloud
# Author:: Ian Duffy (<ian@ianduffy.ie>)
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


actions :run

default_action :run

attribute :name, :name_attribute => true, :kind_of => String
attribute :management_server_ip, :kind_of => String, :default => node['ipaddress']
attribute :management_server_port, :kind_of => Integer, :default => 8096
attribute :admin_apikey, :kind_of => String
attribute :admin_secretkey, :kind_of => String
attribute :database_server_ip, :kind_of => String, :default => '127.0.0.1'
attribute :database_server_port, :kind_of => Integer, :default => 3306
attribute :database_user, :kind_of => String, :default => 'cloud'
attribute :database_password, :kind_of => String, :default => 'password'
attribute :database, :kind_of => String, :default => 'cloud'

attr_accessor :exists
