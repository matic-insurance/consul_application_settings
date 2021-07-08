RSpec.describe ConsulApplicationSettings::Providers::Consul do
  let(:provider) { described_class.new(base_path, config) }
  let(:base_path) { '' }
  let(:config) { ConsulApplicationSettings::Configuration.new }

  before do
    set_consul_value('cas_test_root/a/b', '111')
    set_consul_value('cas_test_value', '222')
    set_consul_value('cas_test_string', 'asdfg')
    set_consul_value('cas_test_list', %w[a b c])
    set_consul_value('cas_test_bool', true)
    set_consul_value('cas_test_int', 5)
    set_consul_value('cas_test_float', 0.3)
  end

  describe '#get' do
    context 'when base path is empty' do
      it 'correctly retrieves complex paths' do
        expect(provider.get('cas_test_root/a/b')).to eq(111)
      end

      it 'correctly retrieves simple paths' do
        expect(provider.get('cas_test_value')).to eq(222)
      end
    end

    context 'when base path is present' do
      let(:base_path) { 'cas_test_root' }

      it 'correctly retrieves complex paths' do
        expect(provider.get('a/b')).to eq(111)
      end

      it 'correctly retrieves simple paths' do
        expect(provider.get('cas_test_value')).to eq('')
      end
    end

    context 'when the key is a symbol' do
      it 'correctly retrieves data' do
        expect(provider.get(:cas_test_value)).to eq(222)
      end
    end

    context 'when connection errors are disabled' do
      it 'does not raise error for system exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Errno::EADDRNOTAVAIL
        expect { provider.get(:name) }.not_to raise_error
      end

      it 'does not raise error for faraday exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Faraday::ConnectionFailed.new('error')
        expect { provider.get(:name) }.not_to raise_error
      end

      it 'does not raise error for diplomat exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Diplomat::PathNotFound
        expect { provider.get(:name) }.not_to raise_error
      end
    end

    context 'when connection errors are enabled' do
      let(:config) do
        ConsulApplicationSettings::Configuration.new.tap { |config| config.disable_consul_connection_errors = false }
      end

      it 'raises error for system exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Errno::EADDRNOTAVAIL
        expect { provider.get(:name) }.to raise_error(Errno::EADDRNOTAVAIL)
      end

      it 'does not raise error for faraday exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Faraday::ConnectionFailed.new('error')
        expect { provider.get(:name) }.to raise_error(Faraday::ConnectionFailed)
      end

      it 'does not raise error for diplomat exception' do
        allow(Diplomat::Kv).to receive(:get).and_raise Diplomat::PathNotFound
        expect { provider.get(:name) }.to raise_error(Diplomat::PathNotFound)
      end
    end

    it 'returns string values' do
      expect(provider.get('cas_test_string')).to eq('asdfg')
    end

    it 'returns list values' do
      expect(provider.get('cas_test_list')).to eq(%w[a b c])
    end

    it 'returns boolean values' do
      expect(provider.get('cas_test_bool')).to eq(true)
    end

    it 'returns integer values' do
      expect(provider.get('cas_test_int')).to eq(5)
    end

    it 'returns float values' do
      expect(provider.get('cas_test_float')).to eq(0.3)
    end
  end
end
