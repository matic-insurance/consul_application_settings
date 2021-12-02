module ConsulApplicationSettings
  module Resolvers
    # Run values through ERB
    class Erb
      IDENTIFIER = /(<%).*(%>)/.freeze

      def resolvable?(value, _path)
        return unless value.is_a?(String)

        IDENTIFIER.match?(value)
      end

      def resolve(value, _path)
        ERB.new(value.to_s).result
      end
    end
  end
end
