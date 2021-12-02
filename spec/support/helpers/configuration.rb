module Helpers
  module Configuration
    def fixture_path(defaults_fixture)
      File.expand_path("../fixtures/#{defaults_fixture}.yml", __dir__)
    end
  end
end

RSpec.configure do |config|
  config.include(Helpers::Configuration)

  config.before(:each, :default_settings_file) do
    ConsulApplicationSettings.configure do |settings_config|
      settings_config.base_file_path = fixture_path('base_application_settings')
    end
  end

  config.after(:each, :default_settings_file) do
    ConsulApplicationSettings.config = ConsulApplicationSettings::Configuration.new
  end
end
