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