# Create OpenVAS certificate
execute "openvas-mkcert" do
  command "openvas-mkcert -q"
  action :run
  not_if "test -e /var/lib/openvas/CA/cacert.pem"
end

# Create /var/lib/openvas/plugins
directory "/var/lib/openvas/plugins" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if "test -d /var/lib/openvas/plugins" 
end

# Update OpenVAS network vulnerability tests 
execute "openvas-nvt-sync" do
  command "openvas-nvt-sync; sleep 5m"
  action :run
  not_if "COUNT=`ls -alh /var/lib/openvas/plugins/a* |wc -l`; [ $COUNT -gt 50 ] && echo true; "
end

# Create SSL client certificate for user om
execute "openvas-mkcert-client" do
  command "openvas-mkcert-client -n om -i"
  action :run
  not_if "test -d /var/lib/openvas/users/om"
end

# Migrate/rebuild database on 1st run
execute "openvassd" do
  command "openvassd"
  user    "root"
  action :run
  not_if "netstat -nlp |grep openvassd"
end

# Rebuild openvasmd-rebuild
execute "openvasmd-rebuild" do
  command "openvasmd --rebuild"
  user    "root"
  action :run
  not_if "test -d /var/lib/openvas/users/admin"
end

# Execute killall openvassd
execute "killall-openvassd" do
  command "killall openvassd"
  user    "root"
  action :run
  not_if "test -d /var/lib/openvas/users/admin"
end

# Sleep for 15 seconds
execute "sleep" do
  command "sleep 15"
  user    "root"
  action :run
  not_if "test -d /var/lib/openvas/users/admin"
end

# Enable & start openvas-scanner service
service "openvas-scanner" do
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Enable & start openvas-manager service
service "openvas-manager" do
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => false, :condrestart => true
  action [ :enable, :start ]
end

# Enable & start openvas-administrator service
service "openvas-administrator" do
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => false, :condrestart => true
  action [ :enable, :start ]
end

# Enable & start greenbone-security-assistant service
service "gsad" do
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
  action [ :enable, :start ]  
end
