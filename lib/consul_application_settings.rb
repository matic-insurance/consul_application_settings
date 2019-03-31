require "consul_application_settings/version"
require "consul_application_settings/configuration"
require "consul_application_settings/defaults"
require "consul_application_settings/options"
require "diplomat"

module ConsulApplicationSettings
  class Error < StandardError; end

  class << self
    attr_accessor :config
    attr_accessor :defaults
  end

  self.config ||= ConsulApplicationSettings::Configuration.new

  class << self
    def configure
      yield(config)
      self.defaults = ConsulApplicationSettings::Defaults.read(config.defaults_path)
    end

    def get_from(path)
      ConsulApplicationSettings::Options.new(path, defaults.get_from(path))
    end

    def get
      get_from('')
    end
  end
end
