# Cookbook Name:: joomla
# Recipe:: php
#
# Install / configure PHP5 for Joomla
# 

package 'php5-mysql'
package 'php5-fpm'
package 'libapache2-mod-php5'

# Is mcrypt already installed?  The following may not be needed ...?
package 'php5-mcrypt'

# Probably do not need this, but handy
package 'php5-cli'

# Composer is used to install dependencies for php-github-api.  This lib is
# used by the admin site.  There are probably better ways to include the lib
# as part of the Joomla! component?  Or perhaps use a joomla-specific solution.
package 'curl'
package 'php5-curl'

bash 'Install composer' do
  code 'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer'
  not_if "which composer"
end
