#
# Cookbook Name:: cloudstack
# Recipe:: eventbus
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
# Configure Cloudstack management-server to send events in RabbitMQ.
# Only work on acs4.3 and later

directory '/etc/cloudstack/management/META-INF/cloudstack/core' do
  owner "root"
  group "root"
  recursive true
  action :create
  only_if do ::Dir.exists?('/etc/cloudstack/management') end
end

template '/etc/cloudstack/management/META-INF/cloudstack/core/spring-event-bus-context.xml' do
  source 'spring-event-bus-context.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(:host     => node['cloudstack']['event']['RabbitMQEventBus']['host'],
            :port     => node['cloudstack']['event']['RabbitMQEventBus']['port'],
            :username => node['cloudstack']['event']['RabbitMQEventBus']['username'],
            :password => node['cloudstack']['event']['RabbitMQEventBus']['password'],
            :exchange => node['cloudstack']['event']['RabbitMQEventBus']['exchange']
            )
  notifies :restart, "service[cloudstack-management]", :delayed
  only_if do ::Dir.exists?('/etc/cloudstack/management') end
end
