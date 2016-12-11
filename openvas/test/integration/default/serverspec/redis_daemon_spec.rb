require 'serverspec'

set :backend, :exec

describe 'redis daemon' do

  it 'has a redis-server service running' do
    expect(service('redis-server')).to be_running
  end

  it 'has redis listening on port 6379' do
    expect(port(6379)).to be_listening
  end
end