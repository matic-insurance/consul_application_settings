RSpec.describe ConsulApplicationSettings::Providers::ConsulPreloaded do
  let(:provider) { described_class.new(base_path, config) }
  let(:base_path) { '' }
  let(:config) { instance_double(ConsulApplicationSettings::Configuration) }

  before do
    set_consul_value('foo', 'bar')
    set_consul_value('root/level_2/level_2_child', 'child_value')
    set_consul_value('root/level_2/level_3/level_4', 'descendant_value')
    set_consul_value('values/string', 'a string')
    set_consul_value('values/int_as_string', '2222')
    set_consul_value('values/integer', 123)
    set_consul_value('values/float', 5.0)
    set_consul_value('values/empty', nil)
    set_consul_value('values/boolean_true', true)
    set_consul_value('values/boolean_false', false)
  end

  it_behaves_like 'a provider' do
    let(:config) { instance_double(ConsulApplicationSettings::Configuration) }
  end

  describe '#get' do
    context 'when value updated on consul' do
      it 'returns old value' do
        provider
        set_consul_value('foo', 'baz')
        expect(provider.get('foo')).to eq('bar')
      end
    end

    context 'when connection errors are disabled' do
      let(:config) do
        instance_double(ConsulApplicationSettings::Configuration, disable_consul_connection_errors: true)
      end

      it 'does not raise error for system exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Errno::EADDRNOTAVAIL
        expect { provider }.not_to raise_error
        expect(provider.get('foo')).to eq(nil)
      end

      it 'does not raise error for faraday exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Faraday::ConnectionFailed.new('error')
        expect { provider }.not_to raise_error
      end

      it 'does not raise error for diplomat exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Diplomat::PathNotFound
        expect { provider }.not_to raise_error
      end
    end

    context 'when connection errors are enabled' do
      let(:config) do
        instance_double(ConsulApplicationSettings::Configuration, disable_consul_connection_errors: false)
      end

      it 'raises error for system exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Errno::EADDRNOTAVAIL
        expect { provider }.to raise_error(Errno::EADDRNOTAVAIL)
      end

      it 'does not raise error for faraday exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Faraday::ConnectionFailed.new('error')
        expect { provider }.to raise_error(Faraday::ConnectionFailed)
      end

      it 'does not raise error for diplomat exception' do
        allow(Diplomat::Kv).to receive(:get_all).and_raise Diplomat::PathNotFound
        expect { provider }.to raise_error(Diplomat::PathNotFound)
      end
    end
  end
end
