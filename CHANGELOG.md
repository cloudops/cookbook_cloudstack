cloudstack CHANGELOG
====================

This file is used to list changes made in each version of the co-cloudstack cookbook.

4.0.5
-----
- pdion891 - add repo for mysql-connector-python

4.0.4
-----
- pdion891 - update apt repo issue for missing pkg signature.
           - fix warning for chef 13.

4.0.1
-----
- pdion891 - update release to 4.8 by default

4.0.0
-----
- pdion891 - integration to berkshelf and vagrant.
           - update for new acs 4.6 release.

3.1.1
-----
- pdion891 - POST for login authentication use to generate admin api_keys
           - update systemvm url for acs 4.5

3.1.0
-----
- pdion891 - support cookbook mysql6

3.0.10
------
- pdion891 - fix port_open: localhost-> 127.0.0.1

3.0.9
-----
- pdion891 - fix sudoers.

3.0.8
-----
- pdion891 - update date in header.
           - readme typos

3.0.7
-----
- pdion891 - rename ``hypervisor_tpl`` by ``systemvm``

3.0.6
-----
- pdion891 - update 4.4.1 systemplate urls

3.0.5
-----
- pdion891 - fix systemvmtemplate url selection

3.0.4
-----
- pdion891 - api_key: major rewrite part1.

3.0.3
-----
- pdion891 - api_key: add existing keys validation to fix admin password change.

3.0.2
-----
- pdion891 - Add eventlog to rabbitmq config template

3.0.0
-----
- pdion891 - Complete rewrite of co-cloudstack as cloudstack using Chef LWRP
- pdion891 - Rename cookbook from co-cloudstack to cloudstack.

2.0.3
-----
- pdion891 - Add mysql-conf to configure mysql-server tunings required by CloudStack.

2.0.2
-----
- pdion891 - change way of generating APIkeys by querying CloudStack API instead of enabling integration api port.

2.0.0
-----
- pdion891 - add support for CS 4.3

1.0.0
-----
- pdion891 - add vhd-util recipe
- Update license headers
- Update dependencies for opscode cookbooks

0.1.2
-----
- pdion891 - remove use of databag and use attributes instead.

0.1.0
-----
- pdion891 - Initial release of co-cloudstack

