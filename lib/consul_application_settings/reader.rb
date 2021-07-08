module ConsulApplicationSettings
  # Provides access to settings stored in Consul or in file system
  class Reader
    def initialize(base_path, config)
      @providers = config.settings_providers.map { |provider| provider.new(base_path, config) }
    end

    def get(path)
      @providers.each do |provider|
        value = provider.get(path)
        return value unless value.nil?
      end
      nil
    end

    alias [] get
  end
end
