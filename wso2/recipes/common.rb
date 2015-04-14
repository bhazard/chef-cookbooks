# Shared Dependencies 
include_recipe 'apt'
include_recipe 'zip'
include_recipe 'java' if node['wso2']['install_java']
include_recipe 'swap_tuning'