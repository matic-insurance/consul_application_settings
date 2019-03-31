require 'yaml'

module ConsulApplicationSettings
  class Defaults
    attr_reader :contents
    def initialize(hash)
      @contents = hash
    end

    def get(name)
      contents[name.to_s]
    end

    def get_from(path)
      self.class.new contents[path.to_s] || {}
    end

    def self.read(path)
      new YAML.load(IO.read(path))
    rescue => e
      raise ConsulApplicationSettings::Error.new("Cannot read defaults file at #{path}: #{e.message}")
    end
  end
end