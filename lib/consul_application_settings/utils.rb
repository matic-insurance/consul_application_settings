module ConsulApplicationSettings
  # Utility methods to cast values and work with path
  module Utils
    SEPARATOR = '/'.freeze
    PARSING_CLASSES = [Integer, Float, ->(value) { JSON.parse(value) }].freeze

    class << self
      def cast_consul_value(value)
        return nil if value.nil?
        return false if value == 'false'
        return true if value == 'true'
        return value if value.is_a?(Hash)
        return convert_to_hash(value) if value.is_a?(Array)

        cast_complex_value(value)
      end

      def generate_path(*parts)
        strings = parts.map(&:to_s)
        all_parts = strings.map { |s| s.split(SEPARATOR) }.flatten
        all_parts.reject(&:empty?).join('/')
      end

      def decompose_path(path)
        parts = path.to_s.split(SEPARATOR).compact
        parts.reject(&:empty?)
      end

      protected

      def cast_complex_value(value)
        PARSING_CLASSES.each do |parser|
          return parser.call(value)
        rescue StandardError => _e
          nil
        end
        value.to_s
      end

      def convert_to_hash(data)
        data_h = data.map do |item|
          value = cast_consul_value(item[:value])
          item[:key].split('/').reverse.reduce(value) { |h, v| { v => h } }
        end
        data_h.reduce({}) do |dest, source|
          DeepMerge.deep_merge!(source, dest, { preserve_unmergeables: true })
        end
      end
    end
  end
end
