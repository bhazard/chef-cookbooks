# Defaults for WSO2 cookbook

# Location of the downloaded install files from the WSO2 website (WSO2 won't 
# allow direct automated download).  I cache a version as a release on github 
# for this project, but if you wish to update versions, you will need
# your own location
default['wso2']['download_url_base'] = 'https://github.com/bhazard/saltstack-formulas/releases/download/v0.5-alpha'
default['wso2']['download_dir'] = Chef::Config[:file_cache_path] 
default['wso2']['tarball_extension'] = '.zip'
default['wso2']['init_script'] = 'bin/wso2server.sh'

# This will probably vary by OS, but let's default to '/opt' -- (/usr/local is preferred for some)
default['wso2']['install_root'] = '/opt'

# Versions of each component -- these must match the files in the download location, specified above
default['wso2']['wso2as_version'] = '5.2.1'
default['wso2']['wso2bam_version'] = '2.5.0'
default['wso2']['wso2emm_version'] = '1.1.0'
default['wso2']['wso2esb_version'] = '4.8.1'
default['wso2']['wso2is_version'] = '5.0.0'

default['wso2']['wso2greg_version'] = '4.6.0'
default['wso2']['wso2ues_version'] = '1.0.0'


%w(wso2as wso2bam wso2emm wso2esb wso2greg wso2is wso2ues).each do |component|
  default['wso2']["#{component}_tarball_url"] = "#{node['wso2']['download_url_base']}/#{component}-#{node['wso2'][component+'_version']}#{node['wso2']['tarball_extension']}"
  default['wso2']["#{component}_install_dir"] = "#{node['wso2']['install_root']}/#{component}-#{node['wso2'][component+'_version']}"
end

# WSO2 requires Oracle, either version 6 or 7.  As of this writing (March 2015),
# at least some components complain if you try to use 8.
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '7'
default['java']['oracle']['accept_oracle_download_terms'] = true
