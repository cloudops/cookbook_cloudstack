# Author:: Pierre-Luc Dion <pdion@cloudops.com>
# Copyright:: Copyright (c) 2014 CloudOps.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
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
# Test if a TCP port is open and return true or false
# return boolean
# cut&paste snipet from :http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open


require 'socket'
require 'timeout'


module Cloudstack
  
  def port_open(ip, port, seconds=1)
    Timeout::timeout(seconds) do
      begin
        TCPSocket.new(ip, port).close
        true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        false
      end
    end
  rescue Timeout::Error
    false
  end

  # Test if CloudStack Database already exist
  def db_exist?(db_host="localhost", db_user="cloud", db_password="password")
    # test if database exist and is reachable
    Chef::Log.debug "Checking to see if database cloud exist on: '#{db_host}'"
    db_exist = shell_out("mysql -h #{db_host} -u #{db_user} -p#{db_password} -e 'show databases;'|grep cloud")
  end

end