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

template '/etc/apache2/conf-available/joomla-security.conf' do
  source 'apache-joomla-security.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[apache2]"
end

link '/etc/apache2/conf-enabled/joomla-security.conf' do
  to '/etc/apache2/conf-available/joomla-security.conf'
  notifies :restart, "service[apache2]"
end

# The security.conf file is taken careof in the joomla security file.  The
# security.conf file has poor choices wrt index files that we need to
# replace.  So we kill it here to avoid having it interfere with our settings.
file '/etc/apache2/conf-enabled/security.conf' do
  action :delete
end

