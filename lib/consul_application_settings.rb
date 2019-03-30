require "consul_application_settings/version"
require "consul_application_settings/configuration"
require "consul_application_settings/defaults"
require "diplomat"

module ConsulApplicationSettings
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
    attr_accessor :defaults
  end

  self.configuration ||= ConsulApplicationSettings::Configuration.new

  class << self
    def configure
      yield(configuration)
      self.defaults = ConsulApplicationSettings::Defaults.read(configuration.defaults_path)
    end

    def get_from(path)
    end
  end
end
