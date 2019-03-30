module ConsulApplicationSettings
  class Options
    attr_reader :path, :defaults

    def initialize(path, defaults)
      @path = path
      @defaults = defaults
    end

    def method_missing(name, *args)
      defaults.get(name)
    end
  end
end