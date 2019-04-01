module ConsulApplicationSettings
  # All gem configuration settings
  class Configuration
    # Required attributes
    attr_accessor :defaults_path
    # Optional attributes
    attr_accessor :namespace

    def initialize
      self.namespace = ''
    end
  end
end
