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

# Update the carbon.xml script
  template "#{node['wso2'][component]['install_dir']}/repository/conf/carbon.xml" do
    source "#{component}/carbon-#{node['wso2'][component]['version']}.xml.erb"
    mode "0755"
    variables({hostname: "#{component}.wso2.local",
               script_name: "#{node['wso2'][component]['service_name']}"
              })
#    notifies :restart, "service[#{node['wso2']['bam']['service_name']}]"
  end


# Create an init script
  template "/etc/init.d/#{service_name}" do
    source "generic_init_script.erb"
    mode "0755"
    variables({install_dir: install_dir,
               script_name: "#{service_name}",
               init_script: new_resource.init_script})
  end
  
# Enable the service and configure it to autostart.

  log "Service name is #{service_name}"
  if node['wso2']['auto_start'] then
    service "#{service_name}" do
      action [:start, :enable]
      supports :restart => true, :reload => true
    end
  end

  new_resource.updated_by_last_action(true)
end
