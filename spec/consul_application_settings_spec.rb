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

  describe '.configure' do
    let(:local_file_path) { 'path2' }

    before { described_class.configure { |config| config.local_file_path = local_file_path } }

    it 'applies values to configuration' do
      expect(described_class.config.local_file_path).to eq(local_file_path)
    end

    it 'preserves default values' do
      expected = ConsulApplicationSettings::Configuration::DEFAULT_BASE_FILE_PATH
      expect(described_class.config.base_file_path).to eq(expected)
    end
  end
end
