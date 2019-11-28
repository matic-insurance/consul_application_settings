RSpec.describe 'ConsulApplicationSettings without available consul' do
  let(:settings) { ConsulApplicationSettings.load }

  before { Diplomat.configuration.url = 'http://localhost:8888' }
  after { Diplomat.configuration.url = 'http://localhost:8500' }

  context 'when config.disable_consul_connection_errors is true' do
    before do
      configure_settings do |config|
        config.disable_consul_connection_errors = true
      end
    end

    it 'return default value' do
      expect(settings.get('ping')).to eq('pong')
    end

    it 'not raising errors' do
      expect { settings.get('ping') }.not_to raise_error
    end
  end

  context 'when config.disable_consul_connection_errors is false' do
    before do
      configure_settings do |config|
        config.disable_consul_connection_errors = false
      end
    end

    it 'raises error' do
      expect { settings.get('ping') }.to raise_error(Diplomat::PathNotFound)
    end
  end

  context 'when config.disable_consul_connection_errors is default' do
    it 'raises error' do
      expect { settings.get('ping') }.to raise_error(Diplomat::PathNotFound)
    end
  end
end