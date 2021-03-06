default['log-monitor']['develop'] = true

# Elasticsearch defaults
default['log-monitor']['elasticsearch']['auto_start'] = true
default['log-monitor']['elasticsearch']['network_host'] = 'localhost'

# Kibana defaults
default['log-monitor']['kibana']['auto_start'] = true
default['log-monitor']['kibana']['network_host'] = 'localhost'

# Logstash defaults
default['log-monitor']['logstash']['auto_start'] = true

# Install and configure java if desired
default['log-monitor']['install_java'] = true
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true
