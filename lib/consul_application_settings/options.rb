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
        cast_value(consul_value)
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
      "#{path}/#{name.to_s}"
    end

    def cast_value(v)
      case v
      when 'false'
        false
      when 'true'
        true
      else
        Integer(v) rescue Float(v) rescue JSON.parse(v) rescue v
      end
    end
  end
end