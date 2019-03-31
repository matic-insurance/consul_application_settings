module ConsulApplicationSettings
  module Utils
    def self.cast_consul_value(v)
      return false if v == 'false'
      return true if v == 'true'

      cast_complex_value(v) rescue v
    end

    protected

    def self.cast_complex_value(v)
      Integer(v) rescue Float(v) rescue JSON.parse(v)
    end
  end
end