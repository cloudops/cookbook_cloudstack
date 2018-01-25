#
# Cookbook Name:: cloudstack
# Recipe:: default
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

include_recipe 'yum'

yum_repository 'cloudstack' do
  description 'Apache Cloudstack'
  baseurl node['cloudstack']['repo_url']
  enabled node['cloudstack']['repo_enabled']
  metadata_expire node['cloudstack']['repo_metadata_expire']
  gpgkey node['cloudstack']['repo_sign']
  gpgcheck node['cloudstack']['repo_sign'].empty? ? false : true
  action :create
end

yum_repository 'mysql-connector' do
  description 'MySQL Community connectors'
  baseurl 'http://repo.mysql.com/yum/mysql-connectors-community/el/$releasever/$basearch/'
  gpgkey 'http://repo.mysql.com/RPM-GPG-KEY-mysql'
  gpgcheck true
  action :create
end