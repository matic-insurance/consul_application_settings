require 'diplomat'

module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in Consul
    class Consul < Abstract
      def get(path)
        full_path = absolute_key_path(path)
        value = get_from_consul(full_path)
        ConsulApplicationSettings::Utils.cast_consul_value(value)
      end

      private

      def get_from_consul(path)
        Diplomat::Kv.get(path, {})
      rescue Diplomat::KeyNotFound
        return nil
      rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
        raise e unless @config.disable_consul_connection_errors
      end
    end
  end
end
