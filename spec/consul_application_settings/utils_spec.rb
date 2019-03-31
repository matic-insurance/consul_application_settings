RSpec.describe ConsulApplicationSettings::Utils do
  let(:utils, &method(:described_class))
  
  describe '#generate_path' do
    it 'support single part' do
      expect(utils.generate_path('a')).to eq('a')
    end

    it 'joins two parts' do
      expect(utils.generate_path('a', 'b')).to eq('a/b')
    end

    it 'joins multiple parts' do
      expect(utils.generate_path('a', 'b/c', 'd')).to eq('a/b/c/d')
    end

    it 'removes starting slash' do
      expect(utils.generate_path('/a', 'b')).to eq('a/b')
    end

    it 'removes ending slash' do
      expect(utils.generate_path('a', 'b/')).to eq('a/b')
    end

    it 'skips empty strings' do
      expect(utils.generate_path('', 'a', '', 'b')).to eq('a/b')
    end

    it 'removes duplicated slashes' do
      expect(utils.generate_path('a/', 'b')).to eq('a/b')
    end
  end

  describe '#decompose_path' do
    it 'splits path to parts' do
      expect(utils.decompose_path('a/b/c')).to eq(%w(a b c))
    end

    it 'skips duplicated slashes' do
      expect(utils.decompose_path('a//b/c')).to eq(%w(a b c))
    end

    it 'skips starting slash' do
      expect(utils.decompose_path('/a/b/c')).to eq(%w(a b c))
    end

    it 'removes ending slash' do
      expect(utils.decompose_path('/a/b/c/')).to eq(%w(a b c))
    end
  end
end
