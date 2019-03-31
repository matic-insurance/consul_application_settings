def configure_settings(defaults_fixture)
  ConsulApplicationSettings.configure do |config|
    config.defaults_path = File.expand_path(defaults_fixture_path(defaults_fixture), __FILE__)
  end
end

def defaults_fixture_path(defaults_fixture)
  File.expand_path("../fixtures/#{defaults_fixture}.yml", __FILE__)
end