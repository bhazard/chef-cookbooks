# Environment config for developing the chef recipe for wso2

name 'wso2-chef-development'
description 'Development environment for chef recipes for wso2 nodes'
default_attributes "wso2" => {
  'session_timeout' => 120,
  'auto_start' => false
}
