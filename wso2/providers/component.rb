# wso2_component
# Does the work of installing and configuring the given wso2 component.
# -----------------------------------------------------------------------------

action :install do
  component = new_resource.name
  download_dir = node['wso2']['download_dir']
  tarball_file = "#{download_dir}/#{::File.basename(new_resource.tarball_url)}"
  install_root = node['wso2']['install_root']
  service_name = "wso2#{component}"
  install_dir = new_resource.install_dir

# Create the group and user that the service will run as.  The install_dir
# files should be owned by this user and group.
  group node['wso2']['group'] do
    action :create
  end

  user node['wso2']['user'] do
    action :create
    home install_dir
    gid "#{node['wso2']['group']}"
  end

# Fetch the tarfile remotely if need be
  remote_file tarball_file do
    action :create_if_missing
    source new_resource.tarball_url
  end

# Unzip it into the proper destination location
  execute "unzip -o #{tarball_file} -d #{install_root}" do
#    command "tar -zxvf #{tarball_file}"
    command "unzip -o #{tarball_file} -d #{install_root}"
    creates "#{install_dir}"
  end

  execute "chown -R #{node['wso2']['user']}:#{node['wso2']['group']} #{install_dir}" do
  end

# Create the logs directory
  directory "#{install_dir}/logs" do
    owner node['wso2']['user']
    group node['wso2']['group']
    mode "0774"
  end

  CONFIG_FILES = { 'is-5.0.0' => %w{ conf/carbon.xml conf/tomcat/catalina-server.xml 
      conf/tomcat/carbon/WEB-INF/web.xml conf/security/sso-idp-config.xml
      conf/identity.xml conf/provisioning-config.xml conf/embedded-ldap.xml 
      conf/security/authenticators.xml 
    }
  }

  CONFIG_FILES["#{component}-#{node['wso2'][component]['version']}"].each do |cf|
    template "#{install_dir}/repository/#{cf}" do
      source "#{component}-#{node['wso2'][component]['version']}/#{cf}.erb"
      owner node['wso2']['user']
      group node['wso2']['group']
      mode "0664"
      variables({hostname: node['wso2']['hostname'],
                 login_server: node['wso2']['login_server'],
                 admin_user: node['wso2']['admin_user'],
                 admin_password: node['wso2']['admin_password'],
                 kerberos_enabled: false,
                 kerberos_server: node['wso2']['kerberos_server'],
                 session_timeout: node['wso2']['session_timeout'],
                 script_name: node['wso2']["#{component}"]['service_name']
      })
#    notifies :restart, "service[#{service_name}]", :delayed
    end
  end

  
# Create an init script
  template "/etc/init.d/#{service_name}" do
    source "generic_init_script.erb"
    mode "0755"
    variables({install_dir: install_dir,
               script_name: service_name,
               service_user: node['wso2']['user'],
               init_script: new_resource.init_script})
  end
  
# Enable the service and configure it to autostart.

  if node['wso2']['auto_start'] then
    service "#{service_name}" do
      action [:start, :enable]
      supports :restart => true, :reload => true
    end
  end

  new_resource.updated_by_last_action(true)
end
