require "consul_application_settings/version"
require "consul_application_settings/configuration"
require "consul_application_settings/defaults"
require "consul_application_settings/options"
require "consul_application_settings/utils"
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

    def load_from(path)
      settings_path = ConsulApplicationSettings::Utils.generate_path(config.namespace, path)
      ConsulApplicationSettings::Options.new(settings_path, defaults)
    end

    def load
      load_from('')
    end
  end
end
