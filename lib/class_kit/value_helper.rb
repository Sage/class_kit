module ClassKit
  class ValueHelper

    def self.instance
      @@instance ||= new
    end

    def parse(type:, value:)
      if type == Time
        if value.is_a?(Time)
          value
        elsif value.is_a?(Integer) || value.is_a?(Float) || value.is_a?(BigDecimal)
          Time.at(value)
        else
          Time.parse(value)
        end
      elsif type == Date
        if value.is_a?(Date)
          value
        elsif value.is_a?(Integer)
          Date.at(value)
        else
          Date.parse(value)
        end
      elsif type == DateTime
        if value.is_a?(DateTime)
          value
        elsif value.is_a?(Integer)
          DateTime.at(value)
        else
          DateTime.parse(value)
        end
      elsif type == :bool
        if value == true || value == false
          value
        elsif(/(true|t|yes|y|1)$/i === value.to_s.downcase)
          true
        elsif (/(false|f|no|n|0)$/i === value.to_s.downcase)
          false
        elsif value != nil
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
          value = value.to_s
          raise 'Unable to parse BigDecimal' unless value =~ /\A-?\d+(\.\d*)?/
          BigDecimal(value)
        end
      elsif type == String
        String(value)
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
    rescue => e
      raise ClassKit::Exceptions::InvalidParseValueError,
            "Unable to parse value: #{value} into type: #{type}. Error: #{e}"
    end
  end
end
