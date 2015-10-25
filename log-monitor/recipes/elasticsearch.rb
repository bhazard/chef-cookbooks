#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
# ------------------------------------------------------------------------------

include_recipe 'log-monitor::common'

apt_repository 'elasticache' do
  uri        'http://packages.elastic.co/elasticsearch/1.7/debian'
  components ['stable', 'main']
  key 'D88E42B4'
  keyserver 'keyserver.ubuntu.com'
end

package ['elasticsearch']

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  mode "0755"
  variables(
    :network_host => node['log-monitor']['elasticsearch']['network_host']
  )
end

service 'elasticsearch' do
  action :enable if node['log-monitor']['elasticsearch']['auto_start']
  action :start
  supports :restart => true, :status => true
end
