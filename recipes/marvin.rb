#
# Cookbook Name:: cloudstack
# Recipe:: marvin
# Author:: Olivier Lemasle (<olivier.lemasle@apalia.net>)
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

# When marvin will be available from DEB/RPM packages, we will use it instead of pip.
# That's why we're not using the "poise-python" cookbook.

case node['platform_family']
when 'debian'
  package ['python-dev', 'build-essential', 'python-pip', 'libffi-dev', 'libssl-dev']

when 'rhel'
  package ['python-devel', 'gcc', 'libffi-devel', 'openssl-devel']

  remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
    source 'https://bootstrap.pypa.io/get-pip.py'
  end
  bash 'Install Python pip' do
    code "python #{Chef::Config[:file_cache_path]}/get-pip.py"
  end
end

bash 'Install mysql-connector-python and cloudstack-marvin' do
  code <<-EOH
      pip install --user --upgrade http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-2.0.4.zip#md5=3df394d89300db95163f17c843ef49df
      pip install --user --upgrade cloudstack-marvin
  EOH
end
