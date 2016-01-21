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

# Install the key for this repo.  The keyfile is not under source control.  To
# supply the keyfile, place it in a directory called "keys" under the guest's
# /vagrant directory (on the host, keys will be created in the same directory
# as the Vagrantfile).

remote_file "#{KEYPATH}" do
  source "file:///vagrant/keys/#{KEYNAME}"
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
