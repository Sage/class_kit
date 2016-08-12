module ClassKit
  class Helper

    def initialize
      @hash_helper = HashKit::Helper.new
    end

    def get_attributes(klass)
      return klass.class_variable_get(:@@class_kit_attributes).freeze
    end

    def get_attribute(klass:, name:)
      attribute = get_attributes(klass).detect { |i| i[:name] == name }
      if attribute == nil
        raise ClassKit::Exceptions::AttributeNotFoundError.new("Attribute: #{name}, could not be found.")
      end
      return attribute
    end

    def get_attribute_type(klass:,name:)
      return get_attribute(klass: klass,name: name)[:type]
    end

    def is_class?(klass)
      begin
        if !klass.class_variable_defined?(:@@is_class_kit_class)
          return false
        end
      rescue
        return false
      end

      return true
    end

    def validate_class(klass)
      if !is_class?(klass)
        raise ClassKit::Exceptions::InvalidClassError.new("Class: #{klass} does not implement ClassKit.")
      end
      return true
    end

    def standard_type?(obj)
      [
          String, Fixnum, Numeric, Float, Date, DateTime, Time, Integer, TrueClass, FalseClass, NilClass
      ].detect do |klass|
        obj.is_a?(klass)
      end
    end

    def to_hash(object)
      validate_class(object.class)
      @hash_helper.to_hash(object)
    end

    def from_hash(hash:, klass:)
      validate_class(klass)
      entity = klass.new
      attributes = get_attributes(klass)
      attributes.each do |a|
        key = a[:name]
        type = a[:type]

        if hash[key] == nil
          next
        end

        if is_class?(type)
          value = from_hash(hash: hash[key], klass: type)
        elsif type == Array
          value = hash[key].map do |i|
            if a[:collection_type] != nil
              if is_class?(a[:collection_type])
                from_hash(hash: i, klass: a[:collection_type])
              else
                parse_type(type: a[:collection_type], value: i)
              end
            else
              i
            end
          end
        else
          value = hash[key]
        end
        eval("entity.#{key}=value")
      end
      return entity
    end
    
    def parse_type(type: type, value: value)
      if type == Time
        if value.is_a?(Integer) || value.is_a?(Float)
          value = Time.at(value)
        else
          value = Time.parse(value)
        end
      elsif type == Date
        if value.is_a?(Integer)
          value = Date.at(value)
        else
          value = Date.parse(value)
        end
      elsif type == DateTime
        if value.is_a?(Integer)
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
      elsif type == String
        value = String(value)
      elsif type == Hash
        raise 'Unable to parse Hash'
      elsif type == Array
        raise 'Unable to parse Array'
      elsif type == Hash
        raise 'Unable to parse Hash'
      else
        raise 'Unable to parse'
      end

      return value
    end

  end
end