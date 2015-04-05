# wso2bam role definition
# -----------------------------------------------------------------------------

name "wso2bam"
description "A role to configure our Business Activity Manager servers"
# default_attributes "nginx" => {
#       "log_location" => "/var/log/nginx.log" 
# }
# override_attributes "nginx" => {
#        "gzip" => "on"
# }
run_list "recipe[wso2::bam]"

env_run_lists '_default' => [ 'recipe[wso2::bam]'],
  'development' => [ 'recipe[wso2::bam]', 'recipe[wso2::development]' ],
  'chef-development' => [ 'recipe[wso2::bam]', 'recipe[wso2::development]' ]