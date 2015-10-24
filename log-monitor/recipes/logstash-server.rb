#
# Cookbook Name:: logstash
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
#include_recipe 'zip'
include_recipe 'java' if node['log-monitor']['install_java']

apt_repository 'logstash' do
  uri        'http://packages.elasticsearch.org/logstash/1.5/debian'
  components ['stable', 'main']
  key 'D88E42B4'
  keyserver 'keyserver.ubuntu.com'
end

package ['logstash']