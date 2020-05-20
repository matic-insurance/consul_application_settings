RSpec.describe ConsulApplicationSettings::SettingsProvider do
  let(:provider) { described_class.new('', config) }
  let(:config) do
    ConsulApplicationSettings::Configuration.new.tap do |config|
      config.base_file_path = fixture_path('base_application_settings')
    end
  end

  before do
    set_consul_value('application/services/consul/domain', '0.0.0.0')
  end

  describe '#get' do
    it 'gets value from consul if it exists' do
      expect(provider.get('application/services/consul/domain')).to eq('0.0.0.0')
    end

    it 'gets value from file if it does not exist unb Consul' do
      expect(provider.get('application/name')).to eq('NestedStructure')
    end
  end
end
