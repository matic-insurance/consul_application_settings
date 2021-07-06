module ConsulApplicationSettings
  # Provides access to settings stored in Consul or in file system
  class ExperimentalSettingsProvider
    def initialize(base_path, config)
      @file_provider = FileProvider.new(base_path, config)
    end

    def get(path)
      @file_provider.get(path)
    end

    alias [] get
  end
end
