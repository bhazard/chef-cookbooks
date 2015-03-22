#
# Cookbook Name:: wso2
# Recipe:: bam
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'zip'
include_recipe 'java'

wso2_component 'wso2bam' do
  tarball_url node['wso2']['bam']['tarball_url']
  download_dir node['wso2']['download_dir']
  install_dir node['wso2']['bam']['install_dir']
  init_script node['wso2']['init_script']
end
