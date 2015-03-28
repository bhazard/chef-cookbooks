name             'wso2'
maintainer       'Bill Hazard'
maintainer_email 'YOUR_EMAIL'
license          'Apache-2.0'
description      'Installs/Configures WSO2 server components'
long_description 'Installs/Configures WSO2 server components'
version          '0.5.0'

recipe 'default', 'Installs all the SOA related tools'
#recipe 'wso2greg', 'Installs WSO2 Registry'
#recipe 'wso2ues', 'Installs WSO2 User Engagement Server'
recipe 'as', 'Installs WSO2 Application Server'
recipe 'bam', 'Installs WSO2 Business Activity Monitor'
recipe 'emm', 'Installs WSO2 Enterprise Mobility Manager'
recipe 'esb', 'Installs WSO2 Enterprise Service Bus'
recipe 'is', 'Installs WSO2 Identity Server'

%w[ubuntu debian].each do |os|
  supports os
end

%w[apt java zip].each do |dp|
  depends dp
end

# Development dependencies ... is there a way to have these only for dev envs?
depends 'vim', '~> 1.1.2'
depends 'subversion', '~> 1.3.0'
depends 'maven', '~> 1.3.0'
