name             'log-monitor'
maintainer       'Bill Hazard'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures log-monitor'
long_description 'Installs/Configures log-monitor'
version          '0.1.0'

%w[ubuntu debian].each do |os|
  supports os
end

depends 'apt'
depends 'java'
depends 'nginx'