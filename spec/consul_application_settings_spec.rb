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

  describe '.configure' do
    it 'fails when defaults file missing' do
      expect { configure_settings('missing_file.yml') }.to raise_error(ConsulApplicationSettings::Error)
    end

    it 'fails when defaults is not YAML' do
      expect { configure_settings('invalid_syntax.yml') }.to raise_error(ConsulApplicationSettings::Error)
    end

    it 'reads YAML' do
      expect { configure_settings('flat_structure.yml') }.to_not raise_error
    end
  end

  describe '.get' do
    let(:settings) { described_class.get }
    before { configure_settings('flat_structure.yml') }

    it 'return default value' do
      expect(settings.application).to eq("FlatStructure")
    end
  end
end
