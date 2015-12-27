
include_recipe 'joomla::gitssh'

REPO='empty-joomla-template'
SITE_DOCUMENT_ROOT="/var/www/#{REPO}"
JOOMLA_DATABASE='empty_joomla'

# Joomla install section
directory "/var/www/#{REPO}" do
  owner node['joomla']['user']
  group node['joomla']['group']
  mode 0775
  action :create
end


# Consider using the deploy resource?
git SITE_DOCUMENT_ROOT do
  repository "git@github.com:workwave-marketing/#{REPO}.git"
  reference 'master'
  user 'vagrant'
  group node['joomla']['group']
  ssh_wrapper "/home/vagrant/.ssh/new-#{REPO}_gitssh.sh" 
#  environment 'GIT_SSH' => "/home/vagrant/.ssh/new-#{REPO}_gitssh.sh" 
  action :sync
end


# Configure Joomla
WRITEABLE_CONFIGURATION_FILE=true
template File.join(SITE_DOCUMENT_ROOT, 'configuration.php') do
  source 'empty-joomla.configuration.php.erb'
  owner node['joomla']['user']
  group node['joomla']['group']
  if WRITEABLE_CONFIGURATION_FILE
    mode 0664
  else
    mode 0644
  end
  variables ({
    :JoomlaDatabase => JOOMLA_DATABASE
  })
end


# connection_string = "-u#{node['joomla']['db']['user']} \
#                      -p#{node['joomla']['db']['pass']} \
#                      -h #{node['joomla']['db']['host']} \
#                      #{node['joomla']['db']['database']}"

connection_string = JOOMLA_DATABASE

# Need to nuke the DB before 
  
bash 'Import base joomla.sql' do
  code <<-EOH
    mysqladmin -u root create #{JOOMLA_DATABASE}
    mysql #{connection_string} < #{File.join(SITE_DOCUMENT_ROOT, 'data', 'site.sql')}
  EOH
  not_if "mysqlshow -u root | grep #{JOOMLA_DATABASE}"
end

directory 'Remove Joomla Install directory' do
  path File.join(SITE_DOCUMENT_ROOT, 'installation')
  action :delete
  recursive true
end

# ------------------------------
# Fix a bunch of permissions
# ------------------------------

# Writeable by web application, even in prod
%W(cache logs tmp administrator/cache).each do |dir|
  directory "#{SITE_DOCUMENT_ROOT}/#{dir}" do
    group node['joomla']['group']
    mode 0775
    recursive true
  end
end

# Writeable in dev only
%W(
  administrator administrator/components administrator/modules administrator/templates
  administrator/language administrator/language/overrides administrator/language/en-GB
  administrator/manifests/packages administrator/manifests/files administrator/manifests/libraries
  components 
  images images/banners images/sampledata images/headers
  language language/overrides language/en-GB
  libraries media modules 
  plugins plugins/editors plugins/finder plugins/editors-xtd plugins/user plugins/system 
  plugins/content plugins/twofactorauth plugins/captcha plugins/search plugins/quickicon 
  plugins/extension plugins/authentication
  templates).each do |dir|
  directory "#{SITE_DOCUMENT_ROOT}/#{dir}" do
    group node['joomla']['group']
    mode 0775
    recursive true
  end
end


