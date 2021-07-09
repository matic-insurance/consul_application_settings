require 'yaml'

module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in file system with support of base and local files
    class LocalStorage < Abstract
      def initialize(base_path, config)
        super
        @data = load
      end

      def get(path)
        get_value_from_hash(absolute_key_path(path), @data)
      end

      private

      def load
        base_yml = read_yml(base_file_path)
        local_yml = read_yml(local_file_path)
        DeepMerge.deep_merge!(local_yml, base_yml, preserve_unmergeables: false, overwrite_arrays: true,
                              merge_nil_values: true)
      end

      def base_file_path
        @config.base_file_path
      end

      def local_file_path
        @config.local_file_path
      end

      def read_yml(path)
        return {} unless File.exist?(path)

        YAML.safe_load(IO.read(path))
      rescue Psych::SyntaxError, Errno::ENOENT => e
        raise ConsulApplicationSettings::Error, "Cannot read settings file at #{path}: #{e.message}"
      end
    end
  end
end
