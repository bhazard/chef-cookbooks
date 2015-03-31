name 'wso2-development'
description 'Development environment for wso2 nodes'
  # "cookbook_versions": {

  # },
  # "json_class": "Chef::Environment",
  # "chef_type": "environment",
default_attributes "wso2" => {
  'install_dev_tools' => true,
  'session_timeout' => 120
}
