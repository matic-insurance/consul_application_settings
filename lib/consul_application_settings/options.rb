module ConsulApplicationSettings
  class Options
    attr_reader :path, :defaults

    def initialize(path, defaults)
      @path = path
      @defaults = defaults
    end

    def method_missing(name, *args)
      consul_value = Diplomat::Kv.get(name.to_s, {}, :return)
      if consul_value.empty?
        defaults.get(name)
      else
        consul_value
      end
    end
  end
end