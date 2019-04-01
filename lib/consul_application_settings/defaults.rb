require 'yaml'

module ConsulApplicationSettings
  # Reading default file from YAML file and providing interface to query them
  class Defaults
    attr_reader :contents

    def initialize(hash)
      @contents = hash
    end

    def get(name)
      read_value(name, contents)
    end

    def load_from(path)
      keys = ConsulApplicationSettings::Utils.decompose_path(path)
      new_defaults = keys.reduce(contents) { |hash, key| read_value(key, hash, {}) }
      self.class.new(new_defaults)
    end

    def self.read(path)
      new YAML.safe_load(IO.read(path))
    rescue Psych::SyntaxError, Errno::ENOENT => e
      raise ConsulApplicationSettings::Error, "Cannot read defaults file at #{path}: #{e.message}"
    end

    private

    def read_value(key, hash, default = nil)
      hash.fetch(key.to_s, default)
    end
  end
end
