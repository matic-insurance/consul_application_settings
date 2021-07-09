RSpec.describe ConsulApplicationSettings::Providers::Abstract do
  let(:config) { instance_double(ConsulApplicationSettings::Configuration) }
  let(:provider) { described_class.new('', config) }

  describe '#get' do
    it 'is not implemented' do
      expect { provider.get('test') }.to raise_exception(NotImplementedError)
    end
  end
end
