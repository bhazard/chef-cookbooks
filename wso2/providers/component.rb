# wso2_component
# Does the work of installing and configuring the given wso2 component.
# -----------------------------------------------------------------------------

action :install do
  component = new_resource.name
  download_dir = node['wso2']['download_dir']
  tarball_file = "#{download_dir}/#{::File.basename(new_resource.tarball_url)}"
  install_root = "#{node['wso2']['install_root']}"
  service_name = "wso2#{component}"
  install_dir = new_resource.install_dir

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

# Create the logs directory
  directory "#{install_dir}/logs"

  CONFIG_FILES['is-5.0.0'] = %w{ conf/carbon.xml conf/tomcat/catalina-server.xml 
    conf/tomcat/carbon/WEB-INF/web.xml conf/security/sso-idp-config.xml
    conf/identity.xml conf/provisioning-config.xml conf/embedded-ldap.xml 
    conf/security/authenticators.xml 
  }

  CONFIG_FILES["#{component}-#{node['wso2'][component]['version']}"].each do |cf|
    template "#{install_dir}/repository/#{cf}" do
      source "#{component}-#{node['wso2'][component]['version']}/#{cf}.erb"
      owner node['wso2']['user']
      group node['wso2']['group']
      mode "0664"
      variables({hostname: "#{component}.wso2.local",
                 login_server: "#{component}.wso2.local",
                 admin_user: node['wso2']['admin_user'],
                 admin_password: node['wso2']['admin_password'],
                 kerberos_enabled: false,
                 kerberos_server: "#{component}.wso2.local",
                 session_timeout: "#{node['wso2']['session_timeout']}",
                 service_user: "#{node['wso2']['user']}",
                 service_group: "#{node['wso2']['group']}",
                 script_name: "#{node['wso2'][component]['service_name']}"
      })
#    notifies :restart, "service[#{service_name}]"
    end
  end

# # Update the carbon.xml file
#   template "#{install_dir}/repository/conf/carbon.xml" do
#     source "#{component}-#{node['wso2'][component]['version']}/conf/carbon.xml.erb"
#     mode "0755"
#     variables({hostname: "#{component}.wso2.local",
#                script_name: "#{node['wso2'][component]['service_name']}"
#               })
# #    notifies :restart, "service[#{node['wso2']['bam']['service_name']}]"
#   end

# # Update the catalina-server.xml file
#   template "#{install_dir}/repository/conf/tomcat/catalina-server.xml" do
#     source "#{component}-#{node['wso2'][component]['version']}/conf/tomcat/catalina-server.xml.erb"
#     mode "0755"
#     variables({hostname: "#{component}.wso2.local"
#               })
# #    notifies :restart, "service[#{node['wso2']['bam']['service_name']}]"
#   end

# # Update the web.xml file
#   template "#{install_dir}/repository/conf/tomcat/carbon/WEB-INF/web.xml" do
#     source "#{component}-#{node['wso2'][component]['version']}/conf/tomcat/carbon/WEB-INF/web.xml.erb"
#     mode "0755"
#     variables({session_timeout: "#{node['wso2']['session_timeout']}"
#               })
# #    notifies :restart, "service[#{node['wso2']['bam']['service_name']}]"
#   end

# # Update the sso.xml file
#   template "#{install_dir}/repository/conf/security/sso-idp-config.xml" do
#     source "#{component}-#{node['wso2'][component]['version']}/conf/security/sso-idp-config.xml.erb"
#     mode "0755"
#     variables({hostname: "#{component}.wso2.local"
#               })
# #    notifies :restart, "service[#{node['wso2']['bam']['service_name']}]"
#   end

  
# Create an init script
  template "/etc/init.d/#{service_name}" do
    source "generic_init_script.erb"
    mode "0755"
    variables({install_dir: install_dir,
               script_name: "#{service_name}",
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
