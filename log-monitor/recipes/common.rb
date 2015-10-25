# Common setup code for all log-monitor configurations
include_recipe 'vim' if node['log-monitor']['develop']
include_recipe 'apt'
include_recipe 'java' if node['log-monitor']['install_java']
