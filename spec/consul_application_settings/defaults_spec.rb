RSpec.describe ConsulApplicationSettings::Defaults do
  let(:defaults) { described_class.read(path) }

  describe '.get' do
    let(:path) { defaults_fixture_path('flat_structure') }

    it 'returns value' do
      expect(defaults.get('application')).to eq("FlatStructure")
    end

    it 'returns value by symbol' do
      expect(defaults.get(:application)).to eq("FlatStructure")
    end

    it 'returns list values' do
      expect(defaults.get(:collection)).to eq(%w(a b c))
    end

    it 'returns boolean values' do
      expect(defaults.get(:enabled)).to eq(true)
    end

    it 'returns numeric values' do
      expect(defaults.get(:instances)).to eq(4)
    end
  end

  describe '.load_from' do
    let(:path) { defaults_fixture_path('nested_structure') }

    it 'support first level nesting' do
      loaded = defaults.load_from('application')
      expect(loaded.get('name')).to eq("NestedStructure")
    end

    it 'support multi level nesting' do
      loaded = defaults.load_from('application/services/consul')
      expect(loaded.get('domain')).to eq("localhost")
    end

    it 'raises error on arrays' do
      expect { defaults.load_from('collection/0') }.to raise_error
    end
  end
end
