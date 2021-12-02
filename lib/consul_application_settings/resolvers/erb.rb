module ConsulApplicationSettings
  module Resolvers
    class Erb
      IDENTIFIER = /(<%).*(%>)/

      def resolvable?(value, _path)
        return unless value.is_a?(String)

        IDENTIFIER.match?(value)
      end

      def resolve(value, path)
        ERB.new(value.to_s).result
      end
    end
  end
end