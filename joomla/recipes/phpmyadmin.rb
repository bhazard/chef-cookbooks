
# Cookbook Name:: joomla
# Recipe:: phpmyadmin
# 
# Install and configure PHPMyAdmin
# 
# This recipe uses a "raw" package install.  We should replace it with
# a recipe that uses opscode's phpmyadmin cookbook (or equiv)
# -----------------------------------------------------------------------------

# We expect that apache is already installed, as well as PHP
package 'php5-mcrypt'
package 'phpmyadmin'

bash 'Enable mcrypt for phpmyadmin' do
  code 'php5enmod mcrypt'
  not_if 'ls /etc/php5/apache2/conf.d/*mcrypt.ini'
  notifies :restart, "service[apache2]"
end

# Configure apache to serve the site
template '/etc/apache2/sites-available/010-phpmyadmin.conf' do
  source 'phpmyadmin.conf.erb'
  mode 0644
end
link '/etc/apache2/sites-enabled/010-phpmyadmin.conf' do
  to '/etc/apache2/sites-available/010-phpmyadmin.conf'
  notifies :restart, "service[apache2]"
end
