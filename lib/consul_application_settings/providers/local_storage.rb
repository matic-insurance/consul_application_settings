require 'yaml'

module ConsulApplicationSettings
  module Providers
    # Provides access to settings stored in file system with support of base and local files
    class LocalStorage
      def initialize(base_path, config)
        @base_path = base_path
        @config = config
        load
      end

      def get(path)
        read_path(path).clone
      end

      private

      def load
        base_yml = read_yml(base_file_path)
        local_yml = read_yml(local_file_path)
        @data = DeepMerge.deep_merge!(local_yml, base_yml, preserve_unmergeables: false, overwrite_arrays: true,
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

      def read_path(path)
        full_path = ConsulApplicationSettings::Utils.generate_path(@base_path, path)
        parts = ConsulApplicationSettings::Utils.decompose_path(full_path)
        key = parts.pop
        hash = parts.reduce(@data, &method(:traverse))
        hash.fetch(key, nil)
      end

      def traverse(hash, key)
        raise ConsulApplicationSettings::Error, 'reading arrays not implemented' if hash.is_a? Array
        return {} if hash.nil?

        hash.fetch(key.to_s, {})
      end
    end
  end
end
