describe 'logplex installation' do

  it 'should have logplex files' do
    expect(file('/opt/logplex/README.md')).to be_file
  end

  it 'should have supervisor configured' do
    expect(file('/etc/supervisor.d/logplex-service.conf')).to be_file
  end

  it 'should have logplex user' do
    expect(user('logplex')).to exist
  end

  it 'should have logplex group' do
    expect(group('logplex')).to exist
  end

  it 'logplex user should belong to logplex group' do
    expect(user('logplex')).to belong_to_group 'logplex'
  end

end

describe 'logplex running' do

  it 'should have logplex running' do
    expect(service('logplex-service:logplex-service-8001')).to be_running.under('supervisor')
  end

  it 'should have port 8001 listening (API)' do
    expect(port(8001)).to be_listening
  end

  it 'should have port 8601 listening (receive logs)' do
    expect(port(8601)).to be_listening
  end

end

describe 'logplex users' do

  it 'testuser exists' do
    expect(command('echo "logplex_cred:lookup(<<\"testuser\">>)." | erl_call -c 123 -e -name logplex@`hostname`')).to_not return_stdout '{ok, no_such_cred}'
  end

  it 'testuser2 NOT exists' do
    expect(command('echo "logplex_cred:lookup(<<\"testuser2\">>)." | erl_call -c 123 -e -name logplex@`hostname`')).to return_stdout '{ok, no_such_cred}'
  end

end
