#
# Cookbook Name:: cloudstack
# Attribute:: eventbus
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

default['cloudstack']['event']['RabbitMQEventBus']['host'] = 'localhost'
default['cloudstack']['event']['RabbitMQEventBus']['port'] = '5672'
default['cloudstack']['event']['RabbitMQEventBus']['username'] = 'guest'
default['cloudstack']['event']['RabbitMQEventBus']['password'] = 'guest'
default['cloudstack']['event']['RabbitMQEventBus']['exchange'] = 'cloudstack-events'