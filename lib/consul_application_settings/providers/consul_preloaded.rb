module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in Consul. Loads them once
    class ConsulPreloaded < Abstract
      def initialize(base_path, config)
        super
        @data = get_all_from_consul
      end

      def get(path)
        value = get_value_from_hash(absolute_key_path(path), @data)
        value = resolve_tree_response(value)
        ConsulApplicationSettings::Utils.cast_consul_value(value)
      end

      protected

      def get_all_from_consul
        Diplomat::Kv.get_all(@base_path, convert_to_hash: true)
      rescue Diplomat::KeyNotFound
        {}
      rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
        raise e unless @config.disable_consul_connection_errors
        {}
      end

      def resolve_tree_response(value)
        return value unless value.is_a?(Hash)

        deep_cast(value)
      end

      def deep_cast(hash)
        hash.each_pair do |k, v|
          if v.is_a?(Hash)
            deep_cast(v)
          else
            hash[k] = ConsulApplicationSettings::Utils.cast_consul_value(v)
          end
        end
      end
    end
  end
end