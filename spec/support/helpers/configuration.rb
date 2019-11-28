module Helpers
  module Configuration
    def configure_settings(defaults_fixture = 'simple', &block)
      ConsulApplicationSettings.configure do |config|
        config.defaults_path = defaults_fixture_path(defaults_fixture)
        yield(config) if block
      end
    end

    def defaults_fixture_path(defaults_fixture)
      File.expand_path("../fixtures/#{defaults_fixture}.yml", __dir__)
    end

    def clear_gem_configs
      ConsulApplicationSettings.config = ConsulApplicationSettings::Configuration.new
    end
  end
end

RSpec.configure do |config|
  config.include(Helpers::Configuration)

  config.around(:each) do |example|
    configure_settings
    example.run
    clear_gem_configs
  end
end
