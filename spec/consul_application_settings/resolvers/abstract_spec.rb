RSpec.describe ConsulApplicationSettings::Resolvers::Abstract do
  subject(:resolver) { described_class.new }
  let(:value) { [true, 'env://eeee', 1, nil].sample }

  it 'do not resolve value any value' do
    expect(resolver.resolvable?(value)).to be_falsey
  end

  it 'returns original value' do
    expect(resolver.resolve(value)).to eq(value)
  end
end
