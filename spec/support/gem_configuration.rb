def configure_settings(defaults_fixture, &block)
  ConsulApplicationSettings.configure do |config|
    config.defaults_path = defaults_fixture_path(defaults_fixture)
    yield(config) if block
  end
end

def defaults_fixture_path(defaults_fixture)
  File.expand_path("../fixtures/#{defaults_fixture}.yml", __FILE__)
end