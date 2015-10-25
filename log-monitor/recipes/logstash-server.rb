#
# Cookbook Name:: log-monitor
# Recipe:: logstash-server
#
# Copyright (C) 2015 Bill Hazard
#
# All rights reserved - Do Not Redistribute
# ------------------------------------------------------------------------------

include_recipe 'log-monitor::common'

apt_repository 'logstash' do
  uri        'http://packages.elasticsearch.org/logstash/1.5/debian'
  components ['stable', 'main']
  key 'D88E42B4'
  keyserver 'keyserver.ubuntu.com'
end

package ['logstash']

%w(10-syslog.conf 30-syslog.conf).each do |f|
  log "Processing #{f}"
  template "/etc/logstash/conf.d/#{f}" do
    source "logstash-server/#{f}.erb"
    mode "0644"
    variables(
      :network_host => node['log-monitor']['logstash']['network_host']
    )
  end
end

service 'kibana' do
  action :enable if node['log-monitor']['kibana']['auto_start']
  action :start
  supports :restart => true, :status => true
end



service 'logstash' do
  action :enable if node['log-monitor']['logstash']['auto_start']
  action :start
  supports :restart => true, :status => true
end
