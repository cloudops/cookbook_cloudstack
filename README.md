# CloudStack Cookbook

[![Build Status](https://circleci.com/gh/cloudops/cookbook_cloudstack.svg?style=svg)](https://circleci.com/gh/cloudops/cookbook_cloudstack)
[![Cookbook Version](https://img.shields.io/cookbook/v/cloudstack.svg)](https://supermarket.chef.io/cookbooks/cloudstack)
[![license](https://img.shields.io/github/license/cloudops/cookbook_cloudstack.svg)](https://github.com/cloudops/cookbook_cloudstack/blob/master/LICENSE)

Install and configure [Apache Cloudstack](http://cloudstack.apache.org) using [Chef](http://www.chef.io/). A wrapper cookbook is prefered in order to Install Apache CloudStack properly, refer to [cloudstack_wrapper cookbook](https://github.com/cloudops/cookbook_cloudstack_wrapper) for example.

Tested on CentOS 7
Some parts work with Ubuntu 16.04 but this cookbook does not perform all configuraiton required for CloudStack Management-server on Ubuntu.

## Table of Contents

- [About Apache Cloudstack](#about-apache-cloudstack)
- [Requirements](#requirements)
  - [Cookbooks](#cookbooks)
- [Resources / Providers](#resources-providers)
  - [cloudstack_setup_database](#cloudstack_setup_database)
  - [cloudstack_system_template](#cloudstack_system_template)
  - [cloudstack_setup_management](#cloudstack_setup_management)
  - [cloudstack_api_keys](#cloudstack_api_keys)
  - [cloudstack_global_setting](#cloudstack_global_setting)
- [Recipes](#recipes)
  - [cloudstack::management_server](#cloudstackmanagement_server)
  - [cloudstack::usage](#cloudstackusage)
  - [cloudstack::kvm_agent](#cloudstackkvm_agent)
  - [cloudstack::vhd-util](#cloudstackvhd-util)
  - [cloudstack::mysql_conf](#cloudstackmysql_conf)
  - [cloudstack::eventbus](#cloudstackeventbus)
  - [cloudstack::default](#cloudstackdefault)
- [Attributes](#attributes)
- [Contributing](#contributing)
- [License and Authors](#license-and-authors)

## About Apache Cloudstack

Apache CloudStack is open source software designed to deploy and manage large networks of virtual machines, as a highly available, highly scalable Infrastructure as a Service (IaaS) cloud computing platform.

More info on: http://cloudstack.apache.org/

## Requirements

### Cookbooks

- `yum` - packages management
- `apt` - packages management
- `mysql` - for MySQL database server and client
- `sudo` - to configure sudoers for user `cloud`

There is a dependency on Ruby gem [cloudstack_ruby_client](https://github.com/chipchilders/cloudstack_ruby_client) for chef which is handle in `recipe[cloudstack::default]`.

## Resources / Providers

### cloudstack_setup_database

Create MySQL database and connection configuration used by CloudStack management-server using `/usr/bin/cloudstack-setup-databases` utility.

```ruby
# Using attributes
cloudstack_setup_database node['cloudstack']['db']['host'] do
  root_user     node['cloudstack']['db']['rootusername']
  root_password node['cloudstack']['db']['rootpassword']
  user          node['cloudstack']['db']['username']
  password      node['cloudstack']['db']['password']
  action        :create
end
```

```ruby
# using mysql cookbook and CloudStack default passwords
cloudstack_setup_database node['cloudstack']['db']['host'] do
  action        :create
end
```

### cloudstack_system_template

Download initial SystemVM template prior to initialize a CloudStack Region. cloudstack_system_template require access to CloudStack database which must be initated before executing this ressource. If no URL is provided cloudstack_system_template will use the default URL from the database if available to download the template.

```ruby
# Using attributes
cloudstack_system_template 'xenserver' do
  url         node['cloudstack']['systemvm']['xenserver']
  nfs_path    node['cloudstack']['secondary']['path']
  nfs_server  node['cloudstack']['secondary']['host']
  db_user     node['cloudstack']['db']['username']
  db_password node['cloudstack']['db']['password']
  db_host     node['cloudstack']['db']['host']
end
```

Which is equivalent to:

```bash
/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt \
  -m /mnt/secondary \
  -u http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-xen.vhd.bz2 \
  -h xenserver \
  -F
```

Simpler example:

```ruby
# Using URL from CloudStack database
cloudstack_system_template 'kvm' do
end
```

### cloudstack_setup_management

Post package installation and Database Creation for CloudStack, cloudstack-management service must be configure using a script `/usr/bin/cloudstack-setup-management`.

``` ruby
cloudstack_setup_management node.name
```

### cloudstack_api_keys

Generate api keys for account. Currently working only for admin account.

Will update attributes:

- `node['cloudstack']['admin']['api_key']`
- `node['cloudstack']['admin']['secret_key']`

``` ruby
# Create API key if now exist in Cloudstack and update node attributes
cloudstack_api_keys 'admin' do
  action :create
end
```

``` ruby
# Generate new API Keys
cloudstack_api_keys 'admin' do
  action :reset
end
```

### cloudstack_global_setting

Update Global Settings values.

``` ruby
cloudstack_global_setting 'expunge.delay' do
  value '80'
  notifies :restart, 'service[cloudstack-management]', :delayed
end
```

## Recipes

### cloudstack::management_server

Prepare the node to be a CloudStack management server. It will not fully
install CloudStack because of dependency such as MySQL server and system VM
templates. Refer to [cloudstack_wrapper cookbook](https://github.com/cloudops/cookbook_cloudstack_wrapper)
to install a fully working CloudStack management-server.

### cloudstack::usage

Install, enable and start cloudstack-usage. cloudstack-usage is usefull to collect resource usage from account. This recipe make sure cloudstack-usage run on a cloudstack-management server as it is required.

### cloudstack::kvm_agent

Install, enable and start KVM cloudstack-agent. KVM host managed by CloudStack require an agent. This recipe install cloudstack-agent required on a KVM server.

Support Ubuntu and CentOS/RHEL KVM server.

### cloudstack::vhd-util

Download the tool vhd-util which is not include in CloudStack packages and required to manage XenServer hosts.

### cloudstack::mysql_conf

MySQL tunning based on official CloudStack documentation.

### cloudstack::eventbus

Configure CloudStack to send Events into RabbitMQ message bus. Work for CloudStack 4.3 and latest. RabbitMQ must be installed and configured somewhere, default values are for localhost.

### cloudstack::default

Chef Required dependencies in order to interact with CloudStack.

## Attributes

Attributes can be customized. The cookbook does not support encrypted data bag usage for now.

- `node['cloudstack']['yum_repo']` - YUM repo URL to use, default: http://cloudstack.apt-get.eu/rhel/4.3/
- `node['cloudstack']['apt_repo']` - APT repo URL to use, default: http://cloudstack.apt-get.eu/ubuntu
- `node['cloudstack']['release_major']` - Major CloudStack release ex: 4.3 or 4.2
- `node['cloudstack']['version']` - Package version ex: 4.2.1-1.el6

## Contributing

TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

- Author:: Pierre-Luc Dion (<pdion@cloud.ca>)
- Author:: Khosrow Moossavi (<kmoossavi@cloud.ca>)

Some snippets have been taken from: [schubergphilis/cloudstack-cookbook](https://github.com/schubergphilis/cloudstack-cookbook)

- Author:: Roeland Kuipers (<rkuipers@schubergphilis.com>)  
- Author:: Sander Botman (<sbotman@schubergphilis.com>)
- Author:: Hugo Trippaers (<htrippaers@schubergphilis.com>)

```text
Copyright:: Copyright (c) 2018 CloudOps Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
