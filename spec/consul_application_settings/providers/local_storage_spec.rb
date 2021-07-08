RSpec.describe ConsulApplicationSettings::Providers::LocalStorage do
  let(:provider) { described_class.new(base_path, config) }
  let(:base_path) { '' }
  let(:config) do
    ConsulApplicationSettings::Configuration.new.tap do |config|
      config.base_file_path = base_file_path
      config.local_file_path = local_file_path
    end
  end
  let(:base_file_path) { fixture_path('base_application_settings') }
  let(:local_file_path) { fixture_path('local_application_settings') }

  describe '#get' do
    context 'when base path is empty' do
      it 'correctly retrieves complex paths' do
        expect(provider.get('application/services/consul/domain')).to eq('localhost123')
      end

      it 'correctly retrieves simple paths' do
        expect(provider.get('instances')).to eq(4)
      end
    end

    context 'when base path is present' do
      let(:base_path) { 'application' }

      it 'correctly retrieves complex paths' do
        expect(provider.get('services/consul/domain')).to eq('localhost123')
      end

      it 'correctly retrieves simple paths' do
        expect(provider.get('enabled')).to eq(true)
      end
    end

    context 'when local file is absent' do
      let(:local_file_path) { '' }

      it 'correctly retrieves data' do
        expect(provider.get('application/services/consul/domain')).to eq('localhost')
      end
    end

    context 'when the key is a symbol' do
      it 'correctly retrieves data' do
        expect(provider.get(:instances)).to eq(4)
      end
    end

    context 'when key is not found' do
      it 'returns nil' do
        expect(provider.get(:new_key)).to eq(nil)
      end
    end

    it 'returns list values' do
      expect(provider.get(:collection)).to eq(%w[a b c])
    end

    it 'returns boolean values' do
      expect(provider.get(:visible)).to eq(true)
    end

    it 'returns numeric values' do
      expect(provider.get(:instances)).to eq(4)
    end

    it 'clones the value before returning' do
      array = provider.get(:collection)
      array << 'd'
      expect(provider.get(:collection)).to eq(%w[a b c])
    end

    context 'when YML file has invalid syntax' do
      let(:base_file_path) { fixture_path('invalid_syntax') }

      it 'raises error' do
        expect { provider.get(:a) }.to raise_error(ConsulApplicationSettings::Error)
      end
    end
  end
end
