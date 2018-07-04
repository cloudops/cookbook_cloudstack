#
# Cookbook Name:: cloudstack
# provider:: configure cloud
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

include Cloudstack::Helper

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :run do
  if ::File.exists?(new_resource.name)
    wait_count = 0
    until cloudstack_api_is_running? or wait_count == 5 do
      cloudstack_api_is_running?
      sleep(5)
      wait_count +=1
      if wait_count == 1
        Chef::Log.info 'Waiting CloudStack to start'
      end
    end

    if cloudstack_api_is_running?

      template "#{Chef::Config[:file_cache_path]}/marvin.cfg" do
        source new_resource.name
        local true
        variables(
            :management_server_ip => new_resource.management_server_ip,
            :management_server_port => new_resource.management_server_port,
            :admin_apikey => new_resource.admin_apikey,
            :admin_secretkey => new_resource.admin_secretkey,
            :database_server_ip => new_resource.database_server_ip,
            :database_server_port => new_resource.database_server_port,
            :database_user => new_resource.database_user,
            :database_password => new_resource.database_password,
            :database => new_resource.database
        )
      end

      bash 'Configuring the cloud' do
        code "python -m marvin.deployDataCenter -i #{Chef::Config[:file_cache_path]}/marvin.cfg || true"
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::CloudstackConfigureCloud.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.management_server_ip(@new_resource.management_server_ip)
  @current_resource.management_server_port(@new_resource.management_server_port)
  @current_resource.admin_apikey(@new_resource.admin_apikey)
  @current_resource.admin_secretkey(@new_resource.admin_secretkey)
  @current_resource.database_server_ip(@new_resource.database_server_ip)
  @current_resource.database_server_port(@new_resource.database_server_port)
  @current_resource.database_user(@new_resource.database_user)
  @current_resource.database_password(@new_resource.database_password)
  @current_resource.database(@new_resource.database)
end
