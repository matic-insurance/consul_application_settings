require 'diplomat'

module ConsulApplicationSettings
  # Provides access to settings stored in Consul
  class ConsulProvider
    def initialize(base_path, config)
      @base_path = base_path
      @config = config
    end

    def get(path)
      value = fetch_value(path)
      ConsulApplicationSettings::Utils.cast_consul_value(value)
    end

    private

    def fetch_value(path)
      full_path = generate_full_path(path)
      Diplomat::Kv.get(full_path, {}, :return)
    rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
      raise e unless disable_consul_connection_errors?
    end

    def generate_full_path(path)
      ConsulApplicationSettings::Utils.generate_path(@base_path, path)
    end

    def disable_consul_connection_errors?
      @config.disable_consul_connection_errors
    end
  end
end
