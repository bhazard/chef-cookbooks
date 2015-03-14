name             'wso2'
maintainer       'Bill Hazard'
maintainer_email 'YOUR_EMAIL'
license          'Apache-2.0'
description      'Installs/Configures WSO2'
long_description 'Installs/Configures wso2'
version          '0.1.0'

recipe 'default', 'Installs all the SOA related tools'
#recipe 'wso2greg', 'Installs WSO2 Registry'
#recipe 'wso2ues', 'Installs WSO2 User Engagement Server'
recipe 'wso2bam', 'Installs WSO2 Business Activity Monitor'
#recipe 'wso2is', 'Installs WSO2 Identity Server'

%w[ubuntu debian].each do |os|
  supports os
end

%w[apt java zip].each do |dp|
  depends dp
end
