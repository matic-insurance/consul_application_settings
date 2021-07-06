require 'consul_application_settings/version'
require 'consul_application_settings/configuration'
require 'consul_application_settings/consul_provider'
require 'consul_application_settings/file_provider'
require 'consul_application_settings/settings_provider'
require 'consul_application_settings/experimental_settings_provider'
require 'consul_application_settings/utils'

# The gem provides possibility to load settings from Consul and automatically fall back to data stored in file system
module ConsulApplicationSettings
  class Error < StandardError; end

  class << self
    attr_accessor :config
    attr_accessor :defaults
  end

  self.config ||= ConsulApplicationSettings::Configuration.new

  def self.configure
    yield(config)
  end

  def self.load(path = '')
    SettingsProvider.new(path, config)
  end

  def self.load1(path = '')
    ExperimentalSettingsProvider.new(path, config)
  end
end
