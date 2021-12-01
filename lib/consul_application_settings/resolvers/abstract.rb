module ConsulApplicationSettings
  module Resolvers
    class Abstract
      def resolvable?(_value)
        false
      end

      def resolve(value)
        value
      end
    end
  end
end