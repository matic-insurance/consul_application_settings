require 'yaml'

module ConsulApplicationSettings
  class Defaults
    def self.read(path)
      puts YAML.parse(IO.read(path)).inspect
    rescue => e
      raise ConsulApplicationSettings::Error.new("Cannot read defaults file at #{path}: #{e.message}")
    end
  end
end