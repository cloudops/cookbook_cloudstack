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
    conn_db_test = "mysql -h #{db_host} -u #{db_user} -p#{db_password} -e 'show databases;'|grep cloud"
    conn_db_test_out = Mixlib::ShellOut.new(conn_db_test)
    conn_db_test_out.run_command
    if conn_db_test_out.exitstatus == 0
      return true
    else
      return false
    end 
  end

  def cloudstack_is_running?
    # Test if CloudStack Management server is running on localhost.
    port_open('localhost', 8080)
  end

end