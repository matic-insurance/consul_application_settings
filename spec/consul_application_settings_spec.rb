RSpec.describe ConsulApplicationSettings do
  it "has a version number" do
    expect(ConsulApplicationSettings::VERSION).not_to be nil
  end

  it "has get method" do
    expect(ConsulApplicationSettings).to respond_to(:get_from)
  end

  it "has connection to consul" do
    Diplomat::Kv.put('foo', 'bar')
    expect(Diplomat::Kv.get('foo')).to eq('bar')
  end
end
