RSpec.describe ConsulApplicationSettings::Configuration do
  let(:config) { described_class.new }

  context 'default values' do
    it 'has no defaults file' do
      expect(config.defaults_path).to eq(nil)
    end

    it 'has empty namespace' do
      expect(config.namespace).to eq('')
    end
  end
end
