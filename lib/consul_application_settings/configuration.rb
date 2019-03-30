module ConsulApplicationSettings
  class Configuration
    # Required attributes
    attr_accessor :defaults_path
    # Optional attributes
    attr_accessor :namespace

    def initialize
      self.namespace = ""
    end
  end
end
