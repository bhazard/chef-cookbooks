#
# Cookbook Name:: wso2
# Recipe:: is
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wso2::common'

wso2_component 'is' do
  tarball_url node['wso2']['is']['tarball_url']
  install_dir node['wso2']['is']['install_dir']
  init_script node['wso2']['init_script']
end
