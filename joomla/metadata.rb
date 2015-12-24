name             'joomla'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures joomla'
long_description 'Installs/Configures joomla'
version          '0.1.0'

recipe 'joomla::default', 'Installs Joomla 3.x'

%w( debian ubuntu centos redhat fedora amazon ).each do |os|
  supports os
end

# Cookbook dependencies. 
depends 'apt'
depends 'php'
depends 'zip'
depends 'php-fpm'
depends 'mysql'
depends 'hostnames'
depends 'phpmyadmin'

# Development dependencies ... is there a way to have these only for dev envs?
depends 'vim', '~> 2.0'
