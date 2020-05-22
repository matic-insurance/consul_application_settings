module ConsulApplicationSettings
  # All gem configuration settings
  class Configuration
    DEFAULT_BASE_FILE_PATH = 'config/app_settings.yml'.freeze
    DEFAULT_LOCAL_FILE_PATH = 'config/app_settings.local.yml'.freeze
    attr_accessor :base_file_path, :local_file_path, :disable_consul_connection_errors

    def initialize
      @base_file_path = DEFAULT_BASE_FILE_PATH
      @local_file_path = DEFAULT_LOCAL_FILE_PATH
      @disable_consul_connection_errors = true
    end
  end
end
