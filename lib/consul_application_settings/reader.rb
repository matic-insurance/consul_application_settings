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
        check_deep_structure(value, path)
        return value unless value.nil?
      end
      nil
    end

    alias [] get

    def load(sub_path)
      new_path = ConsulApplicationSettings::Utils.generate_path(@base_path, sub_path)
      self.class.new(new_path, @config)
    end

    protected

    def check_deep_structure(value, path)
      return unless value.is_a?(Hash)

      message = "Getting value of complex object at path: '#{path}'. Use #load method to get new scoped instance"
      raise ConsulApplicationSettings::Error, message if value.is_a?(Hash)
    end
  end
end
