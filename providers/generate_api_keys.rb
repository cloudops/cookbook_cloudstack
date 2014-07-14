# Cookbook Name:: cloudstack
# Provider:: generate_api_keys
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
#
# Copyright:: Copyright (c) 2014 CloudOps.com
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
# Generate api keys for specified CloudStack user.


require 'uri'
require 'net/http'
require 'json'
include Chef::Recipe::Cloudstack


action :create do
  if cloudstack_is_running?
    load_current_resource
    generate_api_key(@current_resource.url, @current_resource.username, @current_resource.password)
  else
    Chef::Log.error "CloudStack not running, cannot generate API keys."
  end

end

def load_current_resource
  @current_resource = Chef::Resource::CloudstackGenerateApiKeys.new(@new_resource.name)
  @current_resource.username(@new_resource.name)
  @current_resource.password(@new_resource.password)
  @current_resource.url(@new_resource.url)
  
  #if someting
    #@current_resource.exists = true
  #end
end


def generate_api_key(url, username, password)

  login_params = { :command => "login", :username => username, :password => password, :response => "json" }    
  # create sessionkey and cookie of the api session initiated with username and password
  uri = URI(url)
  uri.query = URI.encode_www_form(login_params)
  res = Net::HTTP.get_response(uri)
  get_keys_params = {
      :sessionkey => JSON.parse(res.body)['loginresponse']['sessionkey'], 
      :command => "registerUserKeys", 
      :response => "json", 
      :id => "2"
  }

  # use sessionkey + cookie to generate admin API and SECRET keys.
  uri2 = URI(url)
  uri2.query = URI.encode_www_form(get_keys_params) 

  get_key = Net::HTTP::Get.new(uri2.to_s)
  get_key['Cookie'] = res.response['set-cookie'].split('; ')[0]

  keys = Net::HTTP.start(uri2.hostname, uri2.port) {|http|
    http.request(get_key)
  }

  keys = {
    api_key => JSON.parse(keys.body)["registeruserkeysresponse"]["userkeys"]["apikey"],
    secret_key => JSON.parse(keys.body)["registeruserkeysresponse"]["userkeys"]["secretkey"]
  }
  return keys
end
