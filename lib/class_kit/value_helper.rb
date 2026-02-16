module ClassKit
  class ValueHelper
    def self.instance
      @@instance ||= new
    end

    def parse(type:, value:)
      if type == :bool
        return value if value == true || value == false

        s = value.to_s
        if Constants::BOOL_TRUE_RE.match?(s)
          true
        elsif Constants::BOOL_FALSE_RE.match?(s)
          false
        elsif !value.nil?
          raise 'Unable to parse bool'
        end
      elsif type == Integer
        Integer(value)
      elsif type == Float
        Float(value)
      elsif type == BigDecimal
        if value.is_a?(BigDecimal)
          value
        else
          s = value.to_s
          raise 'Unable to parse BigDecimal' unless s =~ /\A-?\d+(\.\d*)?/

          BigDecimal(s)
        end
      elsif type == String
        String(value)
      elsif type == Time
        if value.is_a?(Time)
          value
        elsif value.is_a?(Integer) || value.is_a?(Float) || value.is_a?(BigDecimal)
          Time.at(value)
        else
          Time.parse(value)
        end
      elsif type == Date
        value.is_a?(Date) ? value : Date.parse(value)
      elsif type == DateTime
        value.is_a?(DateTime) ? value : DateTime.parse(value)
      elsif type == Regexp
        Regexp.new(value)
      elsif type == Hash
        raise 'Unable to parse Hash' unless value.is_a?(Hash)

        value
      elsif type == Array
        raise 'Unable to parse Array' unless value.is_a?(Array)

        value
      elsif type.include?(ClassKit::CustomType)
        type.parse_assign(value)
      else
        raise 'Unable to parse'
      end
    rescue StandardError => e
      raise ClassKit::Exceptions::InvalidParseValueError,
            "Unable to parse value: #{value} into type: #{type}. Error: #{e}"
    end
  end
end
