name             'cloudstack'
maintainer       'CloudOps, Inc.'
maintainer_email 'pdion@cloudops.com'
license          'Apache 2.0'
description      'Installs/Configures cloudstack'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "yum", '> 3.0.0'
depends "apt", '> 2.2.0'

supports 'centos'
supports 'redhat'
supports 'debian'
supports 'ubuntu'
supports 'fedora'
supports 'oracle'