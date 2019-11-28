RSpec.describe ConsulApplicationSettings::Configuration do
  let(:config) { described_class.new }

  context 'default values' do
    it 'has no defaults file' do
      expect(config.defaults_path).to eq(nil)
    end

    it 'has empty namespace' do
      expect(config.namespace).to eq('')
    end

    it 'raising consul connection errors' do
      expect(config.disable_consul_connection_errors).to be_falsey
    end
  end
end
