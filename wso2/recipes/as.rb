#
# Cookbook Name:: wso2
# Recipe:: as
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wso2::common'

wso2_component 'as' do
  tarball_url node['wso2']['as']['tarball_url']
  install_dir node['wso2']['as']['install_dir']
  init_script node['wso2']['init_script']
end
