RSpec.describe ConsulApplicationSettings::Defaults do
  let(:defaults) { described_class.read(path) }

  context 'flat structure' do
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
end
