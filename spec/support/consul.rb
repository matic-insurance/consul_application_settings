$consul_keys_to_clear = []

RSpec.configure do |config|
  config.after(:each) do
    $consul_keys_to_clear.each do |key|
      Diplomat::Kv.delete(key, recurse: true)
    end
    $consul_keys_to_clear = []
  end
end

def set_custom_value(path, value)
  $consul_keys_to_clear << path
  Diplomat::Kv.put(path, value)
end
