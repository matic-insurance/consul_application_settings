module ConsulApplicationSettings
  module Providers
    # Abstract class with basic functionality
    class Abstract
      def initialize(base_path, config)
        @base_path = base_path
        @config = config
      end

      def get(_path)
        raise NotImplementedError
      end

      protected

      def absolute_key_path(path)
        ConsulApplicationSettings::Utils.generate_path(@base_path, path)
      end

      def get_value_from_hash(path, data)
        parts = ConsulApplicationSettings::Utils.decompose_path(path)
        data.dig(*parts).clone
      end
    end
  end
end
