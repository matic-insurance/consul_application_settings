require 'yaml'

module ConsulApplicationSettings
  class Defaults
    attr_reader :contents

    def initialize(hash)
      @contents = hash
    end

    def get(name)
      read_value(name, contents)
    end

    def load_from(path)
      keys = path.split('/')
      new_defaults = keys.reduce(contents) { |hash, key| read_value(key, hash, {}) }
      self.class.new(new_defaults)
    end

    def self.read(path)
      new YAML.load(IO.read(path))
    rescue => e
      raise ConsulApplicationSettings::Error.new("Cannot read defaults file at #{path}: #{e.message}")
    end

    private

    def read_value(key, hash, default = nil)
      hash.fetch(key.to_s, default)
    end
  end
end