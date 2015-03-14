actions :install

default_action :install

attribute :name, kind_of: String, name_attribute: true
attribute :tarball_url, kind_of: String
attribute :download_dir, kind_of: String, default: Chef::Config[:file_cache_path] 
attribute :src_dir, kind_of: String
attribute :install_dir, kind_of: String
attribute :init_script, kind_of: String, default: 'bin/wso2server.sh'
