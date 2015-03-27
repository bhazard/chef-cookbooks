#
# Cookbook Name:: wso2
# Recipe:: carbon
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'zip'
include_recipe 'java'

wso2_user = 'root'
wso2_group = 'root'

install_dir = "#{node['wso2']['carbon']['install_dir']}"

wso2_component 'carbon' do
  tarball_url node['wso2']['carbon']['tarball_url']
  install_dir install_dir
  init_script node['wso2']['init_script']
end

repos_config_dir = "#{install_dir}/repository/components/p2/org.eclipse.equinox.p2.engine/profileRegistry/default.profile/.data/.settings"

directory repos_config_dir do
  owner wso2_user
  group wso2_group
  mode '0755'
  recursive true
end

template "#{repos_config_dir}/org.eclipse.equinox.p2.artifact.repository.prefs" do
  source 'org.eclipse.equinox.p2.artifact.repository.prefs.erb'
  owner wso2_user
  group wso2_group
  mode '0644'
end

template "#{repos_config_dir}/org.eclipse.equinox.p2.metadata.repository.prefs" do
  source 'org.eclipse.equinox.p2.metadata.repository.prefs.erb'
  owner wso2_user
  group wso2_group
  mode '0644'
end
