RSpec.describe ConsulApplicationSettings do
  it "has a version number" do
    expect(ConsulApplicationSettings::VERSION).not_to be nil
  end

  it "has get method" do
    expect(ConsulApplicationSettings).to respond_to(:get_from)
  end
end
