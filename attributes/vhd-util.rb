#
# Cookbook Name:: co-cloudstack3
# Attribute:: vhd-util
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

# FOLLOWING ATTRIBUTES SHOULD NOT REQUIRE MODIFICATION  
default['cloudstack']['vhd-util_url'] = "http://download.cloud.com.s3.amazonaws.com/tools/vhd-util"
default['cloudstack']['vhd-util_path'] = "/usr/share/cloudstack-common/scripts/vm/hypervisor/xenserver"
