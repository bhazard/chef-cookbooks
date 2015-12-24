# Cookbook Name:: joomla
# Recipe:: apache
# 
# Installs apache2
# We're doing this the simple way -- using a package instead of a cookbook
package 'apache2'

# create the service, but don't do anything when chef sees this definition
# several other recipes muck with apache2 conf files, so will request a
# restart.  no need to start at this point.
service 'apache2' do
  action :nothing
end