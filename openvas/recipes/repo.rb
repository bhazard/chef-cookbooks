# Configure the repository for apt (ubuntu)
apt_repository 'mrazavi-ubuntu-openvas' do
  uri 'http://ppa.launchpad.net/mrazavi/openvas/ubuntu'
  key '4aa450E0'
  components ['main']
end

