module ConsulApplicationSettings
  # Provides access to settings stored in Consul or in file system
  class Reader
    def initialize(base_path, config)
      @base_path = base_path
      @config = config
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

    def load(sub_path)
      new_path = ConsulApplicationSettings::Utils.generate_path(@base_path, sub_path)
      self.class.new(new_path, @config)
    end
  end
end
