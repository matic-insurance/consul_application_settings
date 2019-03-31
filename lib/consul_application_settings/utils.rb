module ConsulApplicationSettings
  module Utils
    SEPARATOR = '/'.freeze

    def self.cast_consul_value(v)
      return false if v == 'false'
      return true if v == 'true'

      cast_complex_value(v) rescue v
    end

    def self.generate_path(*parts)
      strings = parts.map(&:to_s)
      all_parts = strings.map { |s| s.split(SEPARATOR) }.flatten
      non_empty_parts = all_parts.select { |p| !p.empty? }
      non_empty_parts.join('/')
    end

    def self.decompose_path(path)
      parts = path.to_s.split(SEPARATOR).compact
      parts.select { |p| !p.empty? }
    end

    protected

    def self.cast_complex_value(v)
      Integer(v) rescue Float(v) rescue JSON.parse(v)
    end
  end
end