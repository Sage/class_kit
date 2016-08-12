module ClassKit
  def attr_accessor_type(name, type: nil, collection_type: nil, allow_nil: true, default: nil, auto_init: false, meta: {})

    if !self.class_variable_defined?(:@@class_kit_attributes)
      self.class_variable_set(:@@class_kit_attributes, [])
    end

    if !self.class_variable_defined?(:@@is_class_kit_class)
      self.class_variable_set(:@@is_class_kit_class, true)
    end

    attributes = self.class_variable_get(:@@class_kit_attributes)
    attributes.push({ name: name, type: type, collection_type: collection_type, allow_nil: allow_nil, default: default, auto_init: auto_init, meta: meta })
    self.class_variable_set(:@@class_kit_attributes, attributes)

    self.class_eval do
      define_method name do

        cka = self.class.class_variable_get(:@@class_kit_attributes).detect { |i| i[:name] == name }

        if eval("@#{name}") == nil && cka[:default] != nil
          eval("@#{name}=cka[:default]")
        end

        if eval("@#{name}") == nil && cka[:auto_init] == true
          eval("@#{name}=cka[:type].new")
        end

        return eval("@#{name}")
      end
    end

    self.class_eval do
      define_method "#{name}=" do |value|

        #get the attribute meta data
        cka = self.class.class_variable_get(:@@class_kit_attributes).detect { |i| i[:name] == name }

        #verify if the attribute is allowed to be set to nil
        if value == nil && cka[:allow_nil] == false
          raise ClassKit::Exceptions::InvalidAttributeValueError.new("Attribute: #{name}, must not be nil.")
        end

        #check if the value being set is not of the specified type and should attempt to parse the value
        if cka[:type] != nil && value != nil && (cka[:type] == :bool || !value.is_a?(cka[:type]))
          begin
            if cka[:type] == Time
              if value.is_a?(Integer) || value.is_a?(Float)
                value = Time.at(value)
              else
                value = Time.parse(value)
              end
            elsif cka[:type] == Date
              if value.is_a?(Integer)
                value = Date.at(value)
              else
                value = Date.parse(value)
              end
            elsif cka[:type] == DateTime
              if value.is_a?(Integer)
                value = DateTime.at(value)
              else
                value = DateTime.parse(value)
              end
            elsif cka[:type] == :bool
              if value == true || value == false
                value = value
              elsif(/(true|t|yes|y|1)$/i === value.to_s.downcase)
                value = true
              elsif (/(false|f|no|n|0)$/i === value.to_s.downcase)
                value = false
              elsif value != nil
                raise 'Unable to parse bool'
              end
            elsif cka[:type] == Integer
              value = Integer(value)
            elsif cka[:type] == Float
              value = Float(value)
            elsif cka[:type] == String
              value = String(value)
            elsif cka[:type] == Hash
              raise 'Unable to parse Hash'
            elsif cka[:type] == Array
              raise 'Unable to parse Array'
            elsif cka[:type] == Hash
              raise 'Unable to parse Hash'
            else
              raise 'Unable to parse'
            end
          rescue => e
            raise ClassKit::Exceptions::InvalidAttributeValueError.new("Attribute: #{name}, must be of type: #{cka[:type]}. Error: #{e}")
          end
        end

        eval("@#{name}=value")
      end
    end

  end
end