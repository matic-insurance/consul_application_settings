module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in Consul. Loads them once
    class ConsulPreloaded
      def initialize(base_path, config)
        @base_path, @config = base_path, config
        @data = read_all_values
      end

      def get(path)
        full_path = ConsulApplicationSettings::Utils.generate_path(@base_path, path)
        parts = ConsulApplicationSettings::Utils.decompose_path(full_path)
        key = parts.pop
        hash = parts.reduce(@data, &method(:traverse))
        value = hash.fetch(key, nil)
        ConsulApplicationSettings::Utils.cast_consul_value(value)
      end

      protected

      def read_all_values
        Diplomat::Kv.get_all(@base_path, { convert_to_hash: true })
      rescue Diplomat::KeyNotFound
        {}
      rescue SystemCallError, Faraday::ConnectionFailed, Diplomat::PathNotFound => e
        raise e unless @config.disable_consul_connection_errors
      end

      def traverse(hash, key)
        raise ConsulApplicationSettings::Error, 'reading arrays not implemented' if hash.is_a? Array
        return {} if hash.nil?

        hash.fetch(key.to_s, {})
      end
    end
  end
end