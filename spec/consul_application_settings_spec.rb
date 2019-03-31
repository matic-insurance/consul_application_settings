RSpec.describe ConsulApplicationSettings do
  it "has a version number" do
    expect(ConsulApplicationSettings::VERSION).not_to be nil
  end

  it "has load method" do
    expect(ConsulApplicationSettings).to respond_to(:load)
  end

  it "has connection to consul" do
    set_custom_value('foo', 'bar')
    expect(Diplomat::Kv.get('foo')).to eq('bar')
  end

  describe '.configure' do
    it 'fails when defaults file missing' do
      expect { configure_settings('missing_file') }.to raise_error(ConsulApplicationSettings::Error)
    end

    it 'fails when defaults is not YAML' do
      expect { configure_settings('invalid_syntax') }.to raise_error(ConsulApplicationSettings::Error)
    end

    it 'reads YAML' do
      expect { configure_settings('flat_structure') }.to_not raise_error
    end
  end

  describe '.load' do
    let(:settings) { described_class.load }
    before { configure_settings('flat_structure') }

    it 'return default value' do
      expect(settings.application).to eq('FlatStructure')
    end

    it 'returns consul value' do
      set_custom_value("application", 'ConsulSettings')
      expect(settings.application).to eq('ConsulSettings')
    end
  end

  describe '.load_from' do
    let(:settings) { described_class.load_from('application') }
    before { configure_settings('nested_structure') }

    it 'return default value' do
      expect(settings.name).to eq('NestedStructure')
    end

    it 'returns consul value' do
      set_custom_value("application/name", 'ConsulSettings')
      expect(settings.name).to eq('ConsulSettings')
    end

    it 'normalizes path' do
      settings = described_class.load_from('/application/services//consul/')
      expect(settings.domain).to eq('localhost')
    end
  end

  describe 'namespaces' do
    let(:settings) { described_class.load }

    before { configure_settings('namespaced_structure') { |c| c.namespace = 'staging/app1' } }

    it 'return default value' do
      expect(settings.application).to eq('app1')
    end

    it 'returns consul value' do
      set_custom_value("staging/app1/application", 'CustomApp')
      expect(settings.application).to eq('CustomApp')
    end
  end
end
