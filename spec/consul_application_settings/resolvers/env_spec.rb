RSpec.describe ConsulApplicationSettings::Resolvers::Env do
  subject(:resolver) { described_class.new }
  let(:path) { 'application/hostname' }

  describe '#resolvable?' do
    it 'returns true when starts with env://' do
      expect(resolver.resolvable?('env://TEST_URL', path)).to be_truthy
    end

    it 'returns false for nil' do
      expect(resolver.resolvable?(nil, path)).to be_falsey
    end

    it 'returns false for other strings' do
      expect(resolver.resolvable?('envTEST_URL', path)).to be_falsey
    end

    it 'returns false for int' do
      expect(resolver.resolvable?(1, path)).to be_falsey
    end
  end

  describe '#resolve' do
    it 'returns env value' do
      allow(ENV).to receive(:[]).with('TEST_URL').and_return('resolved')
      expect(resolver.resolve('env://TEST_URL', path)).to eq('resolved')
    end

    it 'returns nil when env missing' do
      expect(resolver.resolve('env://TEST_URL', path)).to eq(nil)
    end

    context 'with invalid input' do
      it 'returns using whole value when prefix missing' do
        allow(ENV).to receive(:[]).with('TEST_URL').and_return('resolved')
        expect(resolver.resolve('TEST_URL', path)).to eq('resolved')
      end

      it 'converts to string' do
        allow(ENV).to receive(:[]).with('123').and_return('resolved')
        expect(resolver.resolve(123, path)).to eq('resolved')
      end
    end
  end
end
