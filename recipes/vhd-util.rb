#
# Cookbook Name:: cloudstack
# Recipe:: vhd-util
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
#
# Download vhd-util tool that cannot be distributed.

remote_file "#{node["cloudstack"]["vhd-util_path"]}/vhd-util" do
    source node["cloudstack"]["vhd-util_url"] 
    mode 0755
    action :create_if_missing
    only_if { node['recipes'].include?('cloudstack::management_server') }
end

