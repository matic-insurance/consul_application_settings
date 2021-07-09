RSpec.describe ConsulApplicationSettings::Reader do
  let(:config) do
    ConsulApplicationSettings::Configuration.new.tap do |config|
      config.base_file_path = fixture_path('base_application_settings')
    end
  end
  let(:reader) { described_class.new('', config) }

  context 'default providers' do
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
    let(:provider_class) { double('CustomProvider', new: provider) }
    let(:provider) { instance_double(ConsulApplicationSettings::Providers::Consul) }
    before do
      config.settings_providers = [
        provider_class,
        ConsulApplicationSettings::Providers::LocalStorage
      ]
    end

    before do
      allow(provider).to receive(:get).and_return(nil)
      allow(provider).to receive(:get).with('application/services/consul/domain').and_return('my.domain')
    end

    describe '.initialize' do
      it 'creates custom provider' do
        reader
        expect(provider_class).to have_received(:new).with('', config)
      end
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

  context 'new load' do
    let(:reader) { described_class.new('', config).load('application') }

    before do
      set_consul_value('application/services/consul/domain', '0.0.0.0')
    end

    describe '#get' do
      it 'gets value from consul if it exists' do
        expect(reader.get('services/consul/domain')).to eq('0.0.0.0')
      end

      it 'gets value from file if it does not exist in Consul' do
        expect(reader.get('name')).to eq('NestedStructure')
      end

      it 'returns nil if the key does not exist' do
        expect(reader.get('application/key')).to eq(nil)
      end
    end
  end
end
