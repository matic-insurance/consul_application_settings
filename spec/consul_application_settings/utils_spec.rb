RSpec.describe ConsulApplicationSettings::Utils do
  describe '.generate_path' do
    let(:utils, &method(:described_class))

    it 'support single part' do
      expect(utils.generate_path('part1')).to eq('part1')
    end

    it 'joins two parts' do
      expect(utils.generate_path('part1', 'part2')).to eq('part1/part2')
    end

    it 'joins multiple parts' do
      expect(utils.generate_path('part1', 'part2/part3', 'part4')).to eq('part1/part2/part3/part4')
    end

    it 'removes starting slash' do
      expect(utils.generate_path('/part1', 'part2')).to eq('part1/part2')
    end

    it 'removes ending slash' do
      expect(utils.generate_path('part1', 'part2/')).to eq('part1/part2')
    end

    it 'skips empty strings' do
      expect(utils.generate_path('', 'part1', '', 'part2')).to eq('part1/part2')
    end

    it 'removes duplicated slashes' do
      expect(utils.generate_path('part1/', 'part2')).to eq('part1/part2')
    end
  end
end
