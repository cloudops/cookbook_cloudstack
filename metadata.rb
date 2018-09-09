name             'cloudstack'
maintainer       'CloudOps, Inc.'
maintainer_email 'pdion@cloud.ca'
license          'Apache-2.0'
description      'Installs/Configures cloudstack'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '5.0.0'

source_url 'https://github.com/cloudops/cookbook_cloudstack'
issues_url 'https://github.com/cloudops/cookbook_cloudstack/issues'

depends 'yum', '> 3.0'
depends 'apt', '> 2.0'
depends 'mysql', '~> 8.0'
depends 'sudo', '>= 2.6.0'

supports 'centos'
supports 'redhat'
supports 'debian'
supports 'ubuntu'

chef_version '>= 12.9' if respond_to?(:chef_version)
