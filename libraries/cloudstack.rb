#
# Author:: Pierre-Luc Dion <pdion@cloudops.com>
# Copyright:: Copyright (c) 2014 CloudOps.com
# 
# Test if a TCP port is open and return true or false
# return boolean
# cut&paste snipet from :http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open


require 'socket'
require 'timeout'

#class Chef
#  class Recipe

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

#  end
end