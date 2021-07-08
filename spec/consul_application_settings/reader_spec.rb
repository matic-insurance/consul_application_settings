RSpec.describe ConsulApplicationSettings::Reader do
  context 'default providers' do
    let(:reader) { described_class.new('', config) }
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
        expect(reader.get('application/services/consul/domain')).to eq('0.0.0.0')
      end

      it 'gets value from file if it does not exist in Consul' do
        expect(reader.get('application/name')).to eq('NestedStructure')
      end

      it 'returns nil if the key does not exist' do
        expect(reader.get('application/key')).to eq(nil)
      end
    end
  end

  context 'with custom provider' do
    let(:reader) { described_class.new('', config) }
    let(:provider) { instance_double(ConsulApplicationSettings::Providers::Consul) }
    let(:config) do
      ConsulApplicationSettings::Configuration.new.tap do |config|
        config.base_file_path = fixture_path('base_application_settings')
        config.settings_providers = [
          double('CustomProvider', new: provider),
          ConsulApplicationSettings::Providers::LocalStorage
        ]
      end
    end

    before do
      allow(provider).to receive(:get).and_return(nil)
      allow(provider).to receive(:get).with('application/services/consul/domain').and_return('my.domain')
    end

    describe '#get' do
      it 'gets value from consul if it exists' do
        expect(reader.get('application/services/consul/domain')).to eq('my.domain')
      end

      it 'gets value from file if it does not exist in Consul' do
        expect(reader.get('application/name')).to eq('NestedStructure')
      end

      it 'returns nil if the key does not exist' do
        expect(reader.get('application/key')).to eq(nil)
      end
    end
  end
end
