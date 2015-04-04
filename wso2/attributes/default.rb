# Defaults for WSO2 cookbook
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Parameters that users of this cookbook might want to override
# -----------------------------------------------------------------------------

default['wso2']['hostname'] = 'localhost'
default['wso2']['login_server'] = 'localhost'
default['wso2']['kerberos_server'] = 'localhost'

# User and group under which the service runs.  Any value other than root has
# a couple of bugs:
# Bug 1: There is a bug where the jdk attempts to write a file somewhere and can't
#   get a lock on it.  This tosses an exception in logs/wso2is.err
# Bug 2: The files in logs/ are owned by root:root regardless of the fact that
#   the service is started as user.
default['wso2']['user'] = 'root'
default['wso2']['group'] = 'root'

# Default loginid and pwd for the Carbon admin account
default['wso2']['admin_user'] = 'admin'
default['wso2']['admin_password'] = 'admin'

# Versions of each component -- these must match the files in the download 
# location, and must be compatible with each other.
default['wso2']['carbon']['version'] = '4.2.0'
default['wso2']['as']['version'] = '5.2.1'
default['wso2']['bam']['version'] = '2.5.0'
default['wso2']['emm']['version'] = '1.1.0'
default['wso2']['esb']['version'] = '4.8.1'
default['wso2']['is']['version'] = '5.0.0'
#default['wso2']['greg']['version'] = '4.6.0'
#default['wso2']['ues']['version'] = '1.0.0'

# Set the P2 feature repository name and URL.  This will add a repo for downloading
# new features via the admin console.  N.b. -- the version and URL must match
# the carbon version of whatever product is installed.
default['wso2']['repositories'] = { 'Turing 4.2.0' => 'http\://dist.wso2.org/p2/carbon/releases/turing/' }

# URL for downloading zips.  WSO2 does not provide a direct download, so you'll
# need to supply on your own.  For the modules listed above, the appropriate
# zips are included as part of the downloads for this cookbook.
default['wso2']['download_url_base'] = 'https://github.com/bhazard/chef-cookbooks/releases/download/v0.5.0-beta'

# Downloaded files go here.  This should be *outside* of the VM, but available
# from within the VM.  So /vagrant/x is a good choice.
default['wso2']['download_dir'] = Chef::Config[:file_cache_path]
default['wso2']['tarball_extension'] = '.zip'
default['wso2']['init_script'] = 'bin/wso2server.sh'
default['wso2']['auto_start'] = true
default['wso2']['session_timeout'] = 30 # Tomcat session timeout, in minutes.

# This will vary by OS, but let's default to '/opt'
default['wso2']['install_root'] = '/opt'

%w(carbon as bam emm esb greg is ues).each do |component|
  default['wso2']["#{component}"]['tarball_url'] = "#{node['wso2']['download_url_base']}/wso2#{component}-#{node['wso2'][component]['version']}#{node['wso2']['tarball_extension']}"
  default['wso2']["#{component}"]['install_dir'] = "#{node['wso2']['install_root']}/wso2#{component}-#{node['wso2'][component]['version']}"
  default['wso2']["#{component}"]['service_name'] = "wos2#{component}"
end

# Turing repository URL: http://dist.wso2.org/p2/carbon/releases/turing/
# are new prefs files created in: 
#   repository/components/p2/org.eclipse.equinox.p2.engine/profileRegistry/default.profile/.data/.settings?
# Two files there, org.eclipse.equinox.p2.artifact.repository.prefs 
#              and org.eclipse.equinox.p2.metadata.repository.prefs
# For a new carbon install, the directory ../default.profile contains only 10
#   .gz files and no 

# WSO2 depends on having an Oracle JDK, which we install via the Java Chef Cookbook. 
# Here, we configure the recipe to install JDK version 7.  As of this writing 
# (March 2015), version 6 is supported but at least some components complain 
# if you try to use 8.
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '7'
default['java']['oracle']['accept_oracle_download_terms'] = true

