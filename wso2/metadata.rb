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
recipe 'am', 'Installs WSO2 API Manager'
recipe 'as', 'Installs WSO2 Application Server'
recipe 'bam', 'Installs WSO2 Business Activity Monitor'
recipe 'emm', 'Installs WSO2 Enterprise Mobility Manager'
recipe 'esb', 'Installs WSO2 Enterprise Service Bus'
recipe 'is', 'Installs WSO2 Identity Server'

%w[ubuntu debian].each do |os|
  supports os
end

depends 'apt', '~> 2.6.1'
# bump from 1.31.0
depends 'java', '~> 1.42.0'
depends 'zip', '~> 1.1.0'
depends 'swap_tuning', '~> 0.1.4'
depends 'ssl_certificate', '~> 1.4.0'

# Development dependencies ... is there a way to have these only for dev envs?
depends 'vim', '~> 1.1.2'
depends 'subversion', '~> 1.3.0'
depends 'maven', '~> 1.3.0'
