# wso2_component
# Does the work of installing and configuring the given wso2 component.
# -----------------------------------------------------------------------------

action :install do
  tarball_file = "#{new_resource.download_dir}/#{::File.basename(new_resource.tarball_url)}"
  install_root = "#{node['wso2']['install_root']}"

# Fetch the tarfile remotely if need be
  remote_file tarball_file do
    action :create_if_missing
    source new_resource.tarball_url
  end

# Unzip it into the proper destination location
  execute "unzip -o #{tarball_file} -d #{install_root}" do
#    command "tar -zxvf #{tarball_file}"
    command "unzip -o #{tarball_file} -d #{install_root}"
  end

# Create the logs directory
  directory "#{new_resource.install_dir}/logs"

# Create an init script
  template "/etc/init.d/#{new_resource.name}" do
    source "generic_init_script.erb"
    mode "0755"
    variables({install_dir: new_resource.install_dir,
               script_name: new_resource.name,
               init_script: new_resource.init_script})
  end
  
# Enable the service and configure it to autostart.
  service new_resource.name do
    action [:start, :enable]
    supports :restart => true, :reload => true
  end

  new_resource.updated_by_last_action(true)
end
