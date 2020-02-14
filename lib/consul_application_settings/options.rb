require 'json'

module ConsulApplicationSettings
  # Reads settings from consul or ask defaults for value
  class Options
    attr_reader :path, :defaults

    def initialize(path, defaults)
      @path = path
      @defaults = defaults.load_from(path)
    end

    def load_from(new_path)
      full_path = ConsulApplicationSettings::Utils.generate_path(path, new_path)
      self.class.new(full_path, defaults)
    end

    def get(name)
      consul_value = key_value(name)
      if consul_value.nil? || consul_value.empty?
        defaults.get(name)
      else
        ConsulApplicationSettings::Utils.cast_consul_value(consul_value)
      end
    end

    def [](name)
      get(name)
    end

    # rubocop:disable Style/MethodMissingSuper
    def method_missing(name, *_args)
      get(name)
    end
    # rubocop:enable Style/MethodMissingSuper

    def respond_to_missing?(_name)
      true
    end

    private

    def key_value(name)
      Diplomat::Kv.get(key_path(name), {}, :return)
    rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
      raise e unless ConsulApplicationSettings.config.disable_consul_connection_errors
    end

    def key_path(name)
      ConsulApplicationSettings::Utils.generate_path(path, name)
    end
  end
end
