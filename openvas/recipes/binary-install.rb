# Installs openvas server via binary install from third party (mrazavi)
# -----------------------------------------------------------------------

include_recipe 'openvas::repo'

# Redis?

# PACKAGES = %w{ coreutils texlive-latex-base texlive-latex-extra texlive-latex-recommended htmldoc nsis
#  openvas-manager openvas-scanner openvas-administrator sqlite3 xsltproc wget alien nikto }
LATEX_PACKAGES = %w{ texlive-latex-base texlive-latex-extra texlive-latex-recommended }
UNKNOWN_PACKAGES = %w{ coreutils htmldoc nsis wget }
PACKAGES = %w{ openvas-manager openvas-scanner sqlite3 xsltproc nikto }
CLIENT_PACKAGES = %w{ openvas-client greenbone-security-assistant gsd openvas-cli }
case node['platform']

  when "ubuntu","debian","linuxmint"
    PACKAGES.each do |pkg|
      package pkg
    end

end

# Grab latest copy of checker
# we'd like to use remote_file, but the cert is not valid and no way round that
# with remote_file.  So go manual with wget ...
CHECK_SETUP = '/home/vagrant/openvas-check-setup'
execute 'get openvas-check-setup' do
  command "wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O #{CHECK_SETUP} && chmod 755 #{CHECK_SETUP}"
  creates CHECK_SETUP
end

# Need to run nvt synch
# Run scap sync
#   openvas-scapdata-sync or greenbone-scapdata-sync
#   
#   

execute 'openvas-nvt-sync' do
  command 'openvas-nvt-sync'
  # user 'root'
  action :run
  not_if "COUNT=`ls -alh /var/lib/openvas/plugins/a* |wc -l`; [ $COUNT -gt 50 ] && echo true; "
end

