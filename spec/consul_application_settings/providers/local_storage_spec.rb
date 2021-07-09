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

  it_behaves_like 'a provider' do
    let(:config) do
      ConsulApplicationSettings::Configuration.new.tap do |config|
        config.base_file_path = fixture_path('provider_tests')
      end
    end
  end

  describe 'base and local files' do
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
  end

  context 'when YML file has invalid syntax' do
    let(:base_file_path) { fixture_path('invalid_syntax') }

    it 'raises error' do
      expect { provider.get(:a) }.to raise_error(ConsulApplicationSettings::Error)
    end
  end
end
