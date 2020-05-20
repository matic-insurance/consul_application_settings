RSpec.describe ConsulApplicationSettings do
  it 'has a version number' do
    expect(ConsulApplicationSettings::VERSION).not_to be nil
  end

  it 'has load method' do
    expect(ConsulApplicationSettings).to respond_to(:load)
  end

  it 'has connection to consul' do
    set_consul_value('foo', 'bar')
    expect(Diplomat::Kv.get('foo')).to eq('bar')
  end
end
