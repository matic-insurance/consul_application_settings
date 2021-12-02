RSpec.describe ConsulApplicationSettings::Resolvers::Erb do
  subject(:resolver) { described_class.new }
  let(:path) { 'application/hostname' }

  describe '#resolvable?' do
    it 'returns true when starts has erb' do
      expect(resolver.resolvable?('aaaa<%= 2 + 2 %>', path)).to be_truthy
    end

    it 'returns false when has incorrect erb' do
      expect(resolver.resolvable?('aaaa<% 2 +', path)).to be_falsey
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
    it 'evaluates erb' do
      expect(resolver.resolve('aaaa<%= 2 + 2 %>', path)).to eq('aaaa4')
    end

    it 'has access to env' do
      expect(resolver.resolve("<%= ENV['PATH'] %>", path)).to eq(ENV['PATH'])
    end

    context 'with invalid input' do
      it 'ignores incorrect erb' do
        expect(resolver.resolve('aaaa<%= 2 +', path)).to eq('aaaa 2 +')
      end

      it 'raising error for missing variable' do
        expect { resolver.resolve('<%= path %>', path) }.to raise_error(NameError)
      end

      it 'converts int to string' do
        expect(resolver.resolve(123, path)).to eq('123')
      end
    end
  end
end
