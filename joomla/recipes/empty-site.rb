# Configure this server to host an empty site (possibly in addition to other sites)
# -----------------------------------------------------------------------------

SITE_CONF_FILE='200-empty.conf'
SITE_AVAIL_CONF_PATH="/etc/apache2/sites-available/#{SITE_CONF_FILE}"
SITE_DOCUMENT_ROOT='/var/www/empty'

# Configure apache to serve the site
template SITE_AVAIL_CONF_PATH do
  source 'joomla-site.conf.erb'
  mode 0644
  variables ({
    :ServerName => 'empty.joomla.local',
    :DocumentRoot => SITE_DOCUMENT_ROOT
    })
end
link "/etc/apache2/sites-enabled/#{SITE_CONF_FILE}" do
  to SITE_AVAIL_CONF_PATH
  notifies :restart, "service[apache2]"
end

# Joomla install section
directory SITE_DOCUMENT_ROOT do
  owner node['joomla']['user']
  group node['joomla']['group']
  mode 0755
  action :create
  recursive true
end

# Download joomla
unless node['joomla']['download_url'].empty?
  remote_file "#{Chef::Config[:file_cache_path]}/joomla.zip" do
    source node['joomla']['download_url']
    mode '0644'
    not_if { ::File.exist?(File.join(SITE_DOCUMENT_ROOT, 'index.php')) }
  end
  execute 'Unzip Joomla' do
    cwd SITE_DOCUMENT_ROOT
    command "unzip -q #{Chef::Config[:file_cache_path]}/joomla.zip"
    not_if { ::File.exist?(File.join(SITE_DOCUMENT_ROOT, 'index.php')) }
  end
end

# Configure Joomla
  # template File.join(SITE_DOCUMENT_ROOT, 'configuration.php') do
  #   source 'configuration.php.erb'
  #   owner node['joomla']['user']
  #   group node['joomla']['group']
  #   mode 0644
  # end
  # directory 'Remove Joomla Install directory' do
  #   path File.join(SITE_DOCUMENT_ROOT, 'installation')
  #   action :delete
  #   recursive true
  # end

# bash 'Ensure correct permissions & ownership' do
#   cwd SITE_DOCUMENT_ROOT
#   code <<-EOH
#   chown -R #{node['joomla']['user']}:#{node['joomla']['group']} #{SITE_DOCUMENT_ROOT}
#   EOH
# end