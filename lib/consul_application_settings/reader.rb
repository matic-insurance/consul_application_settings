module ConsulApplicationSettings
  # Orchestrates fetching values from provider and resolving them
  class Reader
    def initialize(base_path, config)
      @base_path = base_path
      @config = config
      @providers = config.settings_providers.map { |provider| provider.new(base_path, config) }
      @resolvers = config.value_resolvers.map(&:new)
    end

    def get(path)
      value = fetch_value(path)
      resolve_value(value, path)
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

    def fetch_value(path)
      @providers.each do |provider|
        value = provider.get(path)
        check_deep_structure(value, path)
        return value unless value.nil?
      end
      nil
    end

    def resolve_value(value, path)
      resolver = @resolvers.detect { |r| r.resolvable?(value, path) }
      if resolver
        resolver.resolve(value, path)
      else
        value
      end
    end
  end
end
