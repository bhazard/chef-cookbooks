#
# Cookbook Name:: joomla
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
# Developer
include_recipe 'vim'

include_recipe 'apt'
include_recipe 'zip'

node.default['set_fqdn'] = '*.joomla.local'
include_recipe 'hostnames::default'

# Install apache before php
include_recipe 'joomla::apache'
include_recipe 'joomla::php'
include_recipe 'joomla::mysql'
include_recipe 'joomla::phpmyadmin'

# for site versioning
package 'git'

# Configure apache to serve the site
template '/etc/apache2/sites-available/100-joomla.conf' do
  source 'joomla-site.conf.erb'
  mode 0644
end
link '/etc/apache2/sites-enabled/100-joomla.conf' do
  to '/etc/apache2/sites-available/100-joomla.conf'
  notifies :restart, "service[apache2]"
end

### PHP-FPM Configuration
# Add Joomla user
user node['joomla']['user'] do
  comment 'Joomla User'
  home node['joomla']['dir']
  shell '/bin/bash'
  system true
end

# Install PHP-FPM
#include_recipe 'php-fpm::default'

# Joomla install section
directory node['joomla']['dir'] do
  owner node['joomla']['user']
  group node['joomla']['group']
  mode 0755
  action :create
  recursive true
end

log "**************"
log "Domain is #{node['joomla']['domain']}"
log "**************"
# Download joomla
unless node['joomla']['download_url'].empty?
  remote_file "#{Chef::Config[:file_cache_path]}/joomla.zip" do
    source node['joomla']['download_url']
    mode '0644'
    not_if { ::File.exist?(File.join(node['joomla']['dir'], 'index.php')) }
  end
  execute 'Unzip Joomla' do
    cwd node['joomla']['dir']
    command "unzip -q #{Chef::Config[:file_cache_path]}/joomla.zip"
    not_if { ::File.exist?(File.join(node['joomla']['dir'], 'index.php')) }
  end
end

# Configure Joomla
  template File.join(node['joomla']['dir'], 'configuration.php') do
    source 'configuration.php.erb'
    owner node['joomla']['user']
    group node['joomla']['group']
    mode 0644
  end

  # Database Configuration stuff
  case node['joomla']['db']['type']
  when 'mysql'
    # bash 'Correct SQL table prefixes before import' do
    #   cwd File.join(node['joomla']['dir'], 'installation', 'sql', 'mysql')
    #   code <<-EOH
    #   sed -i 's/#__/#{node['joomla']['jconfig']['dbprefix']}/g' joomla.sql
    #   EOH
    # end

    connection_string = "-u#{node['joomla']['db']['user']} \
                         -p#{node['joomla']['db']['pass']} \
                         -h #{node['joomla']['db']['host']} \
                         #{node['joomla']['db']['database']}"

    # bash 'Import base joomla.sql' do
    #   code <<-EOH
    #   mysql #{connection_string} < \
    #   #{File.join(node['joomla']['dir'], 'installation', 'sql', 'mysql',
    #               'joomla.sql')}
    #   EOH
    # end

    # Setup Admin User
    # user_file = '/root/user.sql'
    # template user_file do
    #   source 'user.sql.erb'
    #   owner 'root'
    #   group 'root'
    #   mode 0600
    #   variables(
    #     name: node['joomla']['admin_user']['name'],
    #     username: node['joomla']['admin_user']['username'],
    #     password: node['joomla']['admin_user']['password'],
    #     email: node['joomla']['admin_user']['email'],
    #     gid: 8
    #   )
    # end

    # bash 'Initialize admin user' do
    #   code <<-EOH
    #   mysql #{connection_string} < #{user_file}
    #   rm -f #{user_file}
    #   EOH
    # end

  else
    log "Unable to setup database for #{node['joomla']['db']['type']}"
  end

  directory 'Remove Joomla Install directory' do
    path File.join(node['joomla']['dir'], 'installation')
    action :delete
    recursive true
  end

bash 'Ensure correct permissions & ownership' do
  cwd node['joomla']['dir']
  code <<-EOH
  chown -R #{node['joomla']['user']}:#{node['joomla']['group']} \
  #{node['joomla']['dir']}
  EOH
end