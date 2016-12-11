#
# Cookbook Name:: openvas
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'vim'
include_recipe 'nmap'

include_recipe 'openvas::binary-install'