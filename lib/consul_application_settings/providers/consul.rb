require 'diplomat'

module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in Consul
    class Consul
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
        Diplomat::Kv.get(full_path, {})
      rescue Diplomat::KeyNotFound
        return nil
      rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
        raise e unless @config.disable_consul_connection_errors
      end

      def generate_full_path(path)
        ConsulApplicationSettings::Utils.generate_path(@base_path, path)
      end
    end
  end
end
