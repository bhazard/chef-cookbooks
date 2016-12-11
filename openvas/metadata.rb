name             'openvas'
maintainer       'Bill Hazard'
maintainer_email 'bhazard2@gmail.com'
license          'All rights reserved'
description      'Installs/Configures openvas'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


recipe 'default', 'Installs the OpenVAS server and NMap'
#recipe 'wso2greg', 'Installs WSO2 Registry'

depends 'apt', '~> 2.6.1'
depends 'nmap', '> 0.0.0'
depends 'vim', '> 0.0.0'