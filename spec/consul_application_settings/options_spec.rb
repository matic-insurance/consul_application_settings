RSpec.describe ConsulApplicationSettings::Options do
  let(:defaults) { ConsulApplicationSettings::Defaults.read(defaults_fixture_path('nested_structure')) }
  let(:options) { described_class.new(path, defaults) }

  describe 'config values location' do
    context 'root level' do
      let(:path) { '' }

      it 'returns value from defaults' do
        expect(options.get('secret')).to eq('super secret')
      end

      it 'returns value from consul' do
        set_custom_value('secret', 'another secret')
        expect(options.get('secret')).to eq('another secret')
      end
    end

    context 'sub path' do
      let(:path) { 'application/services/consul' }

      it 'returns value from defaults' do
        expect(options.get('domain')).to eq('localhost')
      end

      it 'returns value from consul' do
        set_custom_value('application/services/consul/domain', 'consul.com')
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
          set_custom_value('application/name', 'CustomApp')
          expect(options.get('name')).to eq('CustomApp')
        end
      end

      context 'symbol key' do
        it 'returns value from defaults' do
          expect(options.get(:name)).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_custom_value('application/name', 'CustomApp')
          expect(options.get(:name)).to eq('CustomApp')
        end
      end

      context 'nested key' do
        it 'returns value from defaults' do
          pending('nested defaults key reading implementation')
          expect(options.get('services/consul/domain')).to eq('localhost')
        end

        it 'returns value from consul' do
          set_custom_value('application/services/consul/domain', 'consul.com')
          expect(options.get('services/consul/domain')).to eq('consul.com')
        end
      end
    end

    describe '.[]' do
      context 'string key' do
        it 'returns value from defaults' do
          expect(options['name']).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_custom_value('application/name', 'CustomApp')
          expect(options['name']).to eq('CustomApp')
        end
      end

      context 'symbol key' do
        it 'returns value from defaults' do
          expect(options[:name]).to eq('NestedStructure')
        end

        it 'returns value from consul' do
          set_custom_value('application/name', 'CustomApp')
          expect(options[:name]).to eq('CustomApp')
        end
      end
    end

    describe '.method_missing' do
      it 'returns value from defaults' do
        expect(options.name).to eq('NestedStructure')
      end

      it 'returns value from consul' do
        set_custom_value('application/name', 'CustomApp')
        expect(options.name).to eq('CustomApp')
      end
    end
  end
end
