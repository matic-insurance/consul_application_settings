module Helpers
  module Consul
    attr_accessor :consul_keys

    def set_consul_value(path, value)
      self.consul_keys ||= []
      self.consul_keys << path
      serialized_value = value.is_a?(String) ? value : value.to_json
      Diplomat::Kv.put(path, serialized_value)
    end

    def clear_consul_values
      return unless self.consul_keys

      self.consul_keys.each do |key|
        Diplomat::Kv.delete(key, recurse: true)
      end
      self.consul_keys = []
    end
  end
end

RSpec.configure do |config|
  config.include(Helpers::Consul)

  config.after(:each) do
    clear_consul_values
  end
end
