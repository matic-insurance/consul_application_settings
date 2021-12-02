module ConsulApplicationSettings
  # All gem configuration settings
  class Configuration
    DEFAULT_BASE_FILE_PATH = 'config/app_settings.yml'.freeze
    DEFAULT_LOCAL_FILE_PATH = 'config/app_settings.local.yml'.freeze
    DEFAULT_PROVIDERS = [
      ConsulApplicationSettings::Providers::ConsulPreloaded,
      ConsulApplicationSettings::Providers::LocalStorage
    ]
    DEFAULT_RESOLVERS = [
      ConsulApplicationSettings::Resolvers::Env
    ]
    attr_accessor :base_file_path, :local_file_path, :disable_consul_connection_errors,
                  :settings_providers, :value_resolvers

    def initialize
      @base_file_path = DEFAULT_BASE_FILE_PATH
      @local_file_path = DEFAULT_LOCAL_FILE_PATH
      @disable_consul_connection_errors = true
      @settings_providers = DEFAULT_PROVIDERS
      @value_resolvers = DEFAULT_RESOLVERS
    end
  end
end
