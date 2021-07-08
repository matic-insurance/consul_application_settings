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

  describe 'integration flows', :default_settings_file do
    describe 'providers priority' do
      it 'reads value from consul' do
        set_consul_value('application/name', 'bar')
        settings = ConsulApplicationSettings.load
        expect(settings.get('application/name')).to eq('bar')
      end

      it 'reads value from disk when consul missing' do
        settings = ConsulApplicationSettings.load
        expect(settings.get('application/name')).to eq('NestedStructure')
      end
    end

    describe 'path operations' do
      it 'supports path in load' do
        settings = ConsulApplicationSettings.load('application/services')
        expect(settings.get('consul/domain')).to eq('localhost')
      end

      it 'supports additional path in next load' do
        root_settings = ConsulApplicationSettings.load
        child_settings = root_settings.load('application/services')
        expect(child_settings.get('consul/domain')).to eq('localhost')
      end
    end
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
