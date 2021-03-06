# cloudstack CHANGELOG

This file is used to list changes made in each version of the cloudstack cookbook.

## 6.1.0

- khos2ow - Remove Provider and enhance Custom Resources
- khos2ow - Fix CircleCI configs

## 6.0.1

- khos2ow - Add missing SystemVM URLs for CloudStack 4.10

## 6.0.0

- pdion891 - Fix Chef14 issues on CentOS 7 for cloudstack_setup_database ressource.
- pdion891 - Added circle-ci recipe for automated CI.
- pdion891 - Remove management of sudoers file, pkgs are taking care of it.

## 5.0.0

- pdion891 - update default version to 4.11.
- khos2ow - fixed cookstyle and foodcritic issues.

## 4.1.2

- khos2ow - add default metadata expire to cloudstack repo

## 4.1.1

- khos2ow - add server-id for mysql

## 4.1.0

- khos2ow - add support for enabling/disabling cloudstack repo

## 4.0.8

- pdion891 - put mysql password in single-quotes, otherwise some hardened passwords are not interpreted correctly and logins fail.

## 4.0.7

- pdion891 - add support for CentOS 7 for ACS 4.10 with JDK8

## 4.0.5

- pdion891 - add repo for mysql-connector-python

## 4.0.4

- pdion891 - update apt repo issue for missing pkg signature.
- pdion891 - fix warning for chef 13.

## 4.0.1

- pdion891 - update release to 4.8 by default

## 4.0.0

- pdion891 - integration to berkshelf and vagrant.
- pdion891 - update for new acs 4.6 release.

## 3.1.1

- pdion891 - POST for login authentication use to generate admin api_keys
- pdion891 - update systemvm url for acs 4.5

## 3.1.0

- pdion891 - support cookbook mysql6

## 3.0.10

- pdion891 - fix port_open: localhost-> 127.0.0.1

## 3.0.9

- pdion891 - fix sudoers.

## 3.0.8

- pdion891 - update date in header.
- pdion891 - readme typos

## 3.0.7

- pdion891 - rename ``hypervisor_tpl`` by ``systemvm``

## 3.0.6

- pdion891 - update 4.4.1 systemplate urls

## 3.0.5

- pdion891 - fix systemvmtemplate url selection

## 3.0.4

- pdion891 - api_key: major rewrite part1.

## 3.0.3

- pdion891 - api_key: add existing keys validation to fix admin password change.

## 3.0.2

- pdion891 - Add eventlog to rabbitmq config template

## 3.0.0

- pdion891 - Complete rewrite of co-cloudstack as cloudstack using Chef LWRP
- pdion891 - Rename cookbook from co-cloudstack to cloudstack.

## 2.0.3

- pdion891 - Add mysql-conf to configure mysql-server tunings required by CloudStack.

## 2.0.2

- pdion891 - change way of generating APIkeys by querying CloudStack API instead of enabling integration api port.

## 2.0.0

- pdion891 - add support for CS 4.3

## 1.0.0

- pdion891 - add vhd-util recipe
- pdion891 - Update license headers
- pdion891 - Update dependencies for opscode cookbooks

## 0.1.2

- pdion891 - remove use of databag and use attributes instead.

## 0.1.0

- pdion891 - Initial release of co-cloudstack
