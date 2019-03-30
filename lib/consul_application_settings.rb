require "consul_application_settings/version"
require "consul_application_settings/configuration"
require "diplomat"

module ConsulApplicationSettings
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  self.configuration ||= ConsulApplicationSettings::Configuration.new

  class << self
    def configure
      yield(configuration)
    end

    def get_from(path)
    end
  end
end
