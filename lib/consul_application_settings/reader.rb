module ConsulApplicationSettings
  # Provides access to settings stored in Consul or in file system
  class Reader
    def initialize(base_path, config)
      @consul_provider = ConsulApplicationSettings::Providers::Consul.new(base_path, config)
      @file_provider = ConsulApplicationSettings::Providers::LocalStorage.new(base_path, config)
    end

    def get(path)
      consul_value = @consul_provider.get(path)
      !consul_value.nil? && consul_value != '' ? consul_value : @file_provider.get(path)
    end

    alias [] get
  end
end
