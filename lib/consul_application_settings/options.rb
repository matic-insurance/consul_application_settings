require 'json'

module ConsulApplicationSettings
  class Options
    attr_reader :path, :defaults

    def initialize(path, defaults)
      @path = path
      @defaults = defaults.load_from(path)
    end

    def get(name)
      consul_value = Diplomat::Kv.get(key_path(name), {}, :return)
      if consul_value.nil? || consul_value.empty?
        defaults.get(name)
      else
        ConsulApplicationSettings::Utils.cast_consul_value(consul_value)
      end
    end

    def [](name)
      get(name)
    end

    def method_missing(name, *args)
      get(name)
    end

    private

    def key_path(name)
      ConsulApplicationSettings::Utils.generate_path(path, name)
    end
  end
end