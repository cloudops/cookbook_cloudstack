# Cookbook Name:: cloudstack
# Attribute:: systemvm_template
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


# System VM templates
default['cloudstack']['cloud-install-sys-tmplt'] = '/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt'

case node['cloudstack']['release_major']
when '4.6', '4.7', '4.8', '4.9'
    default['cloudstack']['systemvm'] = {
        'xenserver' => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-xen.vhd.bz2',
        'vmware'    => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-vmware.ova',
        'kvm'       => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-kvm.qcow2.bz2',
        'lxc'       => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-kvm.qcow2.bz2',
        'hyperv'    => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-hyperv.vhd.zip',
        'ovm3'      => 'http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-ovm.raw.bz2'
    }
when '4.5'
    default['cloudstack']['systemvm'] = {
        'xenserver' => 'http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-xen.vhd.bz2',
        'vmware'    => 'http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-vmware.ova',
        'kvm'       => 'http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-kvm.qcow2.bz2',
        'lxc'       => 'http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-kvm.qcow2.bz2',
        'hyperv'    => 'http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-hyperv.vhd.zip'
    }
when '4.4'
    default['cloudstack']['systemvm'] = {
        'xenserver' => 'http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-xen.vhd.bz2',
        'vmware'    => 'http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-vmware.ova',
        'kvm'       => 'http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-kvm.qcow2.bz2',
        'lxc'       => 'http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-kvm.qcow2.bz2',
        'hyperv'    => 'http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-hyperv.vhd'
    }
when '4.3'
    default['cloudstack']['systemvm'] = {
        'xenserver' => 'http://download.cloud.com/templates/4.3/systemvm64template-2014-06-23-master-xen.vhd.bz2',
        'vmware'    => 'http://download.cloud.com/templates/4.3/systemvm64template-2014-06-23-master-vmware.ova',
        'kvm'       => 'http://download.cloud.com/templates/4.3/systemvm64template-2014-06-23-master-kvm.qcow2.bz2',
        'lxc'       => 'http://download.cloud.com/templates/4.3/systemvm64template-2014-06-23-master-kvm.qcow2.bz2',
        'hyperv'    => 'http://download.cloud.com/templates/4.3/systemvm64template-2014-06-23-master-hyperv.vhd.bz2'
    }
when '4.2'
    default['cloudstack']['systemvm'] = {
        'xenserver' => 'http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-2013-07-12-master-xen.vhd.bz2',
        'vmware'    => 'http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-4.2-vh7.ova',
        'kvm'       => 'http://d21ifhcun6b1t2.cloudfront.net/templates/4.2/systemvmtemplate-2013-06-12-master-kvm.qcow2.bz2',
        'lxc'       => 'http://d21ifhcun6b1t2.cloudfront.net/templates/acton/acton-systemvm-02062012.qcow2.bz2'
    }
# when ? : if system VM template not define cloudstack_system_template will look
#          for the URL define into cloudstack database.
end