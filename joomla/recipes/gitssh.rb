# Setup the server to allow pull access from git repo
# 

REPO='empty-joomla-template'
KEYNAME="#{REPO}_rsa"
GITUSER='vagrant'
SSHDIR="/home/#{GITUSER}/.ssh"
KEYPATH="#{SSHDIR}/new-#{KEYNAME}"


# Setup ssh keys.  This scheme will allow us to set GIT_SSH to point to
# a repo-specific script and pull from there.

# Install the repo-specific script
template "#{SSHDIR}/new-#{REPO}_gitssh.sh" do
  source 'gitssh.sh.erb'
  owner GITUSER
  group GITUSER
  mode 0700
  variables ({
    :KeyPath => KEYPATH
    })
end

# Install the key for this repo

cookbook_file "#{KEYPATH}" do
  source "keys/#{KEYNAME}"
  owner GITUSER
  group GITUSER
  mode '0600'
end

# Make sure the vagrant user is a member of the website member group, as this
# user will do the git work for us.

group node['joomla']['group'] do
  action :modify
  members 'vagrant'
  append true
end
