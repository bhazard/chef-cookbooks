# wso2am role definition
# -----------------------------------------------------------------------------

name "wso2am"
description "A role to configure our API manager servers"
# default_attributes "nginx" => {
#       "log_location" => "/var/log/nginx.log" 
# }
# override_attributes "nginx" => {
#        "gzip" => "on"
# }
run_list "recipe[wso2::am]"

env_run_lists '_default' => [ 'recipe[wso2::am]'],
  'development' => [ 'recipe[wso2::am]', 'recipe[wso2::development]' ],
  'chef-development' => [ 'recipe[wso2::am]', 'recipe[wso2::development]' ]