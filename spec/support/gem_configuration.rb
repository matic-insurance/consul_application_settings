def configure_settings(defaults_fixture)
  ConsulApplicationSettings.configure do |config|
    config.defaults_path = File.expand_path("../fixtures/#{defaults_fixture}", __FILE__)
  end
end