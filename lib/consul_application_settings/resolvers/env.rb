module ConsulApplicationSettings
  module Resolvers
    # Resolve values in environment
    class Env
      IDENTIFIER = 'env://'.freeze

      def resolvable?(value, _path)
        return unless value.respond_to?(:start_with?)

        value.start_with?(IDENTIFIER)
      end

      def resolve(value, _path)
        env_path = value.to_s.delete_prefix(IDENTIFIER)
        ENV[env_path]
      end
    end
  end
end
