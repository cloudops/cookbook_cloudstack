#
# Cookbook Name:: cloudstack
# Recipe:: default
#
# Copyright 2014, CloudOps, Inc.
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
include_recipe "cloudstack::management_server"

cloudstack_setup_database 'localhost' do
  root_user 'root'
  root_password 'ilikerandompasswords'
  user 'cloud'
  password 'password'
  action :create
end