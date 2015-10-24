#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'java' if node['log-monitor']['install_java']
include_recipe 'nginx'

apt_repository 'kibana' do
  uri        'http://packages.elastic.co/kibana/4.1/debian'
  components ['stable', 'main']
  key 'D88E42B4'
  keyserver 'keyserver.ubuntu.com'
end

package ['kibana']

template "/opt/kibana/config/kibana.yml" do
  source "kibana.yml.erb"
  mode "0755"
  variables(
    :network_host => node['log-monitor']['kibana']['network_host']
  )
end

service 'kibana' do
  action :enable if node['log-monitor']['kibana']['auto_start']
  action :start
  supports :restart => true, :status => true
end

template "/etc/nginx/sites-available/default" do
  source "nginx-default-config.erb"
  mode "0644"
  variables(
    :network_host => node['log-monitor']['kibana']['network_host']
  )
end

