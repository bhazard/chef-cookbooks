# Installs openvas server via binary install from third party (mrazavi)
# -----------------------------------------------------------------------

include_recipe 'openvas::repo'

# Redis?

# Add the server components
package 'openvas-manager'
package 'openvas-scanner'

# Grab latest copy of checker
# remote_file "#{Chef::Config[:file_cache_path]}/openvas-check-setup" do
#   source 'https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup'
#   mode '0755'
#   action :create_if_missing
# end

# we'd like to use remote_file, but the cert is not valid and no way round that
# with remote_file.  So go manual with wget ...
CHECK_SETUP = '/home/vagrant/openvas-check-setup'
execute 'get openvas-check-setup' do
  command "wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O #{CHECK_SETUP} && chmod 755 #{CHECK_SETUP}"
  creates CHECK_SETUP
#  notifies :run, "file[#{CHECK_SETUP}]", :immediately
end

# file CHECK_SETUP do
#   mode '755'
#   action :nothing
# end