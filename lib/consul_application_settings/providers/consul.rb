require 'diplomat'

module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in Consul
    class Consul < Abstract
      def get(path)
        full_path = absolute_key_path(path)
        value = get_from_consul(full_path)
        value = resolve_tree_response(value, full_path)
        ConsulApplicationSettings::Utils.cast_consul_value(value)
      end

      private

      def get_from_consul(path)
        Diplomat::Kv.get(path, recurse: true)
      rescue Diplomat::KeyNotFound
        return nil
      rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
        raise e unless @config.disable_consul_connection_errors
      end

      def resolve_tree_response(value, full_path)
        return value unless value.is_a?(Array)

        value.each {|item| item[:key] = item[:key].delete_prefix("#{full_path}/")}
        value
      end
    end
  end
end
