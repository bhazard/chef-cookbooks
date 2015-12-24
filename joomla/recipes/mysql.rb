# mysql_service 'default' do
#   port '3306'
#   version '5.5'
#   initial_root_password 'root'
#   action [:create, :start]
# end
# 
package 'mysql-client'
package 'mysql-server'