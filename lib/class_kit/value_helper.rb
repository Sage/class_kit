module ClassKit
  class ValueHelper

    def self.instance
      if !class_variable_defined?(:@@instance)
        class_variable_set(:@@instance, ClassKit::ValueHelper.new)
      end
      return @@instance
    end

    def parse(type: type, value: value)
      begin
      if type == Time
        if value.is_a?(Time)
          value = value
        elsif value.is_a?(Integer) || value.is_a?(Float)
          value = Time.at(value)
        else
          value = Time.parse(value)
        end
      elsif type == Date
        if value.is_a?(Date)
          value = value
        elsif value.is_a?(Integer)
          value = Date.at(value)
        else
          value = Date.parse(value)
        end
      elsif type == DateTime
        if value.is_a?(DateTime)
          value = value
        elsif value.is_a?(Integer)
          value = DateTime.at(value)
        else
          value = DateTime.parse(value)
        end
      elsif type == :bool
        if value == true || value == false
          value = value
        elsif(/(true|t|yes|y|1)$/i === value.to_s.downcase)
          value = true
        elsif (/(false|f|no|n|0)$/i === value.to_s.downcase)
          value = false
        elsif value != nil
          raise 'Unable to parse bool'
        end
      elsif type == Integer
        value = Integer(value)
      elsif type == Float
        value = Float(value)
      elsif type == BigDecimal
        Float(value)
        value = BigDecimal.new(value.to_s)
      elsif type == String
        value = String(value)
      elsif type == Regexp
        value = Regexp.new(value)
      elsif type == Hash
        if !value.is_a?(Hash)
          raise 'Unable to parse Hash'
        end
      elsif type == Array
        if !value.is_a?(Array)
          raise 'Unable to parse Array'
        end
      else
        raise 'Unable to parse'
      end
      rescue => e
        raise ClassKit::Exceptions::InvalidParseValueError.new("Unable to parse value: #{value} into type: #{type}. Error: #{e}")
      end

      return value
    end

  end
end