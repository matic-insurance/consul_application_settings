require 'consul_application_settings/version'
require 'consul_application_settings/configuration'
require 'consul_application_settings/providers/consul'
require 'consul_application_settings/providers/local_storage'
require 'consul_application_settings/reader'
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
    Reader.new(path, config)
  end
end
