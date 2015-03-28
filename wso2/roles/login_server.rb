# login_server role definition
# -----------------------------------------------------------------------------

name "login_server"
description "A role to configure our authentication servers"
# default_attributes "nginx" => {
#       "log_location" => "/var/log/nginx.log" 
# }
# override_attributes "nginx" => {
#        "gzip" => "on"
# }
run_list "recipe[wso2::is]"

env_run_lists '_default' => [ 'recipe[wso2::is]'],
  'development' => [ 'recipe[wso2::is]', 'recipe[wso2::development]' ]