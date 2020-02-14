RSpec.describe ConsulApplicationSettings::Options do
  let(:path) { '' }
  let(:defaults) { ConsulApplicationSettings::Defaults.read(defaults_fixture_path('nested_structure')) }
  let(:options) { described_class.new(path, defaults) }

  describe 'config values location' do
    context 'root level' do
      it 'returns value from defaults' do
        expect(options.get('secret')).to eq('super secret')
      end

      it 'returns value from consul' do
        set_consul_value('secret', 'another secret')
        expect(options.get('secret')).to eq('another secret')
      end
    end

    context 'sub path' do
      let(:path) { 'application/services/consul' }

      it 'returns value from defaults' do
        expect(options.get('domain')).to eq('localhost')
      end

      it 'returns value from consul' do
        set_consul_value('application/services/consul/domain', 'consul.com')
        expect(options.get('domain')).to eq('consul.com')
      end
    end
  end

  describe 'reading values' do
    let(:path) { 'application' }

    describe '.get' do
      context 'string key' do
        it 'returns value from defaults' do
          expect(options.get('name')).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_consul_value('application/name', 'CustomApp')
          expect(options.get('name')).to eq('CustomApp')
        end
      end

      context 'symbol key' do
        it 'returns value from defaults' do
          expect(options.get(:name)).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_consul_value('application/name', 'CustomApp')
          expect(options.get(:name)).to eq('CustomApp')
        end
      end

      context 'nested key' do
        it 'returns value from defaults' do
          expect(options.get('services/consul/domain')).to eq('localhost')
        end

        it 'returns value from consul' do
          set_consul_value('application/services/consul/domain', 'consul.com')
          expect(options.get('services/consul/domain')).to eq('consul.com')
        end
      end

      describe 'connection errors handling' do
        before do
          configure_settings do |config|
            config.disable_consul_connection_errors = true
          end
        end

        it 'not raising error for system exception' do
          allow(Diplomat::Kv).to receive(:get).and_raise Errno::EADDRNOTAVAIL
          expect { options.get(:name) }.not_to raise_error
        end

        it 'not raising error for faraday exception' do
          allow(Diplomat::Kv).to receive(:get).and_raise Faraday::ConnectionFailed.new('error')
          expect { options.get(:name) }.not_to raise_error
        end

        it 'not raising error for faraday exception' do
          allow(Diplomat::Kv).to receive(:get).and_raise Diplomat::PathNotFound.new('error')
          expect { options.get(:name) }.not_to raise_error
        end
      end
    end

    describe '.[]' do
      context 'string key' do
        it 'returns value from defaults' do
          expect(options['name']).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_consul_value('application/name', 'CustomApp')
          expect(options['name']).to eq('CustomApp')
        end
      end

      context 'symbol key' do
        it 'returns value from defaults' do
          expect(options[:name]).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_consul_value('application/name', 'CustomApp')
          expect(options[:name]).to eq('CustomApp')
        end
      end
    end

    describe '.method_missing' do
      it 'returns value from defaults' do
        expect(options.name).to eq('NestedStructure')
      end

      it 'returns value from consul' do
        set_consul_value('application/name', 'CustomApp')
        expect(options.name).to eq('CustomApp')
      end
    end
  end

  describe 'type casting' do
    let(:defaults) { ConsulApplicationSettings::Defaults.read(defaults_fixture_path('flat_structure')) }

    context 'for defaults' do
      it 'returns string valye' do
        expect(options.get(:application)).to eq('FlatStructure')
      end

      it 'returns list values' do
        expect(options.get(:collection)).to eq(%w[a b c])
      end

      it 'returns boolean values' do
        expect(options.get(:enabled)).to eq(true)
      end

      it 'returns integer values' do
        expect(options.get(:instances)).to eq(4)
      end

      it 'returns float values' do
        expect(options.get(:tracking_coefficient)).to eq(0.5)
      end
    end

    context 'for consul' do
      it 'returns string valye' do
        set_consul_value('application', 'CustomApp')
        expect(options.get(:application)).to eq('CustomApp')
      end

      it 'returns list values' do
        set_consul_value('collection', %w[d e f])
        expect(options.get(:collection)).to eq(%w[d e f])
      end

      it 'returns boolean values' do
        set_consul_value('enabled', false)
        expect(options.get(:enabled)).to eq(false)
      end

      it 'returns integer values' do
        set_consul_value('instances', 5)
        expect(options.get(:instances)).to eq(5)
      end

      it 'returns float values' do
        set_consul_value('tracking_coefficient', 0.3)
        expect(options.get(:tracking_coefficient)).to eq(0.3)
      end
    end
  end

  describe '.load_from' do
    let(:new_options) { options.load_from('application/services/consul') }

    it 'returns options object' do
      expect(new_options).to be_instance_of(described_class)
    end

    it 'returns new copy of options' do
      expect(new_options).to_not eq(options)
    end

    it 'returns options with new path' do
      expect(new_options.path).to eq('application/services/consul')
    end

    it 'returns value from defaults' do
      expect(new_options.get('domain')).to eq('localhost')
    end

    it 'returns value from consul' do
      set_consul_value('application/services/consul/domain', 'consul.com')
      expect(new_options.get('domain')).to eq('consul.com')
    end

    it 'normalizes path' do
      settings = options.load_from('/application/services//consul/')
      expect(settings.domain).to eq('localhost')
    end
  end
end
