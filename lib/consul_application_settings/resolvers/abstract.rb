module ConsulApplicationSettings
  module Resolvers
    # Abstract resolver with basic functionality
    class Abstract
      def resolvable?(_value, _path)
        false
      end

      def resolve(value, _path)
        value
      end
    end
  end
end
