#
# Cookbook Name:: wso2
# Recipe:: bam
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wso2::common'

wso2_user = 'root'
wso2_group = 'root'

install_dir = "#{node['wso2']['bam']['install_dir']}"

wso2_component 'bam' do
  tarball_url node['wso2']['bam']['tarball_url']
  install_dir node['wso2']['bam']['install_dir']
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
