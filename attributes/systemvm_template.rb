#
# Cookbook Name:: cloudstack
# Attribute:: systemvm_template
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

default['cloudstack']['secondary']['host'] = node["ipaddress"]
default['cloudstack']['secondary']['path'] = "/data/secondary"
default['cloudstack']['secondary']['mgt_path'] = node['cloudstack']['secondary']['path']

default['cloudstack']['cloud-install-sys-tmplt'] = "/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt"

case node['cloudstack']['version']
when "4.3"
    default['cloudstack']['hypervisor_tpl'] = {
        "xenserver" => "http://download.cloud.com/templates/4.3/systemvm64template-2014-01-14-master-xen.vhd.bz2",
        "vmware" => "http://download.cloud.com/templates/4.3/systemvm64template-2014-01-14-master-vmware.ova",
        "kvm" => "http://download.cloud.com/templates/4.3/systemvm64template-2014-01-14-master-kvm.qcow2.bz2",
        "lxc" => "http://download.cloud.com/templates/4.3/systemvm64template-2014-01-14-master-kvm.qcow2.bz2",
        "hyperv" => "http://download.cloud.com/templates/4.3/systemvm64template-2013-12-23-hyperv.vhd.bz2"
    }
when "4.2.0" || "4.2.1"
    default['cloudstack']['hypervisor_tpl'] = {
        "xenserver" => "http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-2013-07-12-master-xen.vhd.bz2",
        "vmware" => "http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-4.2-vh7.ova",
        "kvm" => "http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-2013-06-12-master-kvm.qcow2.bz2",
        "lxc" => "http://d21ifhcun6b1t2.cloudfront.net/templates/acton/acton-systemvm-02062012.qcow2.bz2"
    }
end
