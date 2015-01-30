cloudstack Cookbook
===================

Install and configure [Apache Cloudstack](http://cloudstack.apache.org) using [Chef](http://www.chef.io/). A wrapper cookbook is prefered in order to Install Apache CloudStack properly, refer to [cloudstack_wrapper cookbook](https://github.com/cloudops/cookbook_cloudstack_wrapper) for example.


Tested on CentOS 6.5 and Ubuntu 14.04


About Apache Cloudstack
-----------------------

Apache CloudStack is open source software designed to deploy and manage large networks of virtual machines, as a highly available, highly scalable Infrastructure as a Service (IaaS) cloud computing platform.

More info on: http://cloudstack.apache.org/

Requirements
------------

#### cookbooks
- `yum` - packages management
- `apt` - packages management
- `mysql` - for MySQL database server and client
- `sudo` - to configure sudoers for user "cloud"

There is a dependency on Ruby gem [cloudstack_ruby_client](https://github.com/chipchilders/cloudstack_ruby_client) for chef which is handle in `recipe[cloudstack::default]`.

Resources/Providers
-------------------

### cloudstack_setup_database

Create MySQL database and connection configuration used by CloudStack management-server using `/usr/bin/cloudstack-setup-databases` utility.

#### Examples

``` ruby
# Using attributes
cloudstack_setup_database node["cloudstack"]["db"]["host"] do
  root_user     node["cloudstack"]["db"]["rootusername"]
  root_password node["cloudstack"]["db"]["rootpassword"]
  user          node["cloudstack"]["db"]["username"]
  password      node["cloudstack"]["db"]["password"]
  action        :create
end
```

```ruby
# using mysql cookbook and CloudStack default passwords
cloudstack_setup_database node["cloudstack"]["db"]["host"] do
  action        :create
end
```

### cloudstack_system_template

Download initial SystemVM template prior to initialize a CloudStack Region. cloudstack_system_template require access to CloudStack database which must be initated before executing this ressource. If no URL is provided cloudstack_system_template will use the default URL from the database if available to download the template.

#### Examples

``` ruby
# Using attributes
cloudstack_system_template 'xenserver' do
  url         node['cloudstack']['systemvm']['xenserver']
  nfs_path    node["cloudstack"]["secondary"]["path"]
  nfs_server  node["cloudstack"]["secondary"]["host"]
  db_user     node["cloudstack"]["db"]["username"]
  db_password node["cloudstack"]["db"]["password"]
  db_host     node["cloudstack"]["db"]["host"]
end
```
Which is equivalent to:

``` bash
/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt \
-m /mnt/secondary \
-u http://cloudstack.apt-get.eu/systemvm/4.4/systemvm64template-4.4.1-7-xen.vhd.bz2 \
-h xenserver \
-F
```

Simpler example: 

``` ruby
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
- `node["cloudstack"]["admin"]["api_key"]`
- `node["cloudstack"]["admin"]["secret_key"]`

#### examples

``` ruby
# Create API key if now exist in Cloudstack and update node attributes
cloudstack_api_keys "admin" do
  action :create
end
```

``` ruby
# Generate new API Keys
cloudstack_api_keys "admin" do
  action :reset
end
```

### cloudstack_global_setting

Update Global Settings values.

#### examples

``` ruby
cloudstack_global_setting "expunge.delay" do
  value "80"
  notifies :restart, "service[cloudstack-management]", :delayed
end
```


Recipes
-------


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


Attributes
----------

Attributes can be customized. The cookbook does not support encrypted data bag usage for now.

- <tt>node['cloudstack']['yum_repo']</tt> - yum repo url to use, default: http://cloudstack.apt-get.eu/rhel/4.3/
- <tt>node['cloudstack']['apt_repo']</tt> - apt repo url to use, default: http://cloudstack.apt-get.eu/ubuntu
- <tt>node['cloudstack']['release_major']</tt> - Major CloudStack release ex: 4.3 or 4.2
- <tt>node['cloudstack']['version']</tt> - Package version ex: 4.2.1-1.el6


Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------
- Author:: Pierre-Luc Dion (<pdion@cloudops.com>)

Some snippets have been taken from: [schubergphilis/cloudstack-cookbook](https://github.com/schubergphilis/cloudstack-cookbook)
- Author:: Roeland Kuipers (<rkuipers@schubergphilis.com>)  
- Author:: Sander Botman (<sbotman@schubergphilis.com>)
- Author:: Hugo Trippaers (<htrippaers@schubergphilis.com>)


```text
Copyright:: Copyright (c) 2015 Author's

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
