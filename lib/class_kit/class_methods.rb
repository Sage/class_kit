module ClassKit
  def attr_accessor_type(name, type: nil, collection_type: nil, allow_nil: true, default: nil, auto_init: false,
                         meta: {})

    unless class_variable_defined?(:@@class_kit_attributes)
      class_variable_set(:@@class_kit_attributes, {})
    end

    attributes = class_variable_get(:@@class_kit_attributes)

    attributes[name] = { name: name, type: type, collection_type: collection_type, allow_nil: allow_nil,
                                  default: default, auto_init: auto_init, meta: meta }

    class_eval do
      define_method name do
        cka = self.class.class_variable_get(:@@class_kit_attributes)[name]

        current_value = instance_variable_get(:"@#{name}")

        if current_value.nil?
          if cka[:default] != nil
            current_value = instance_variable_set(:"@#{name}", cka[:default])
          elsif cka[:auto_init]
            current_value = instance_variable_set(:"@#{name}", cka[:type].new)
          end
        end

        current_value
      end
    end

    class_eval do
      define_method "#{name}=" do |value|
        #get the attribute meta data
        cka = self.class.class_variable_get(:@@class_kit_attributes)[name]

        #verify if the attribute is allowed to be set to nil
        if value.nil? && cka[:allow_nil] == false
          raise ClassKit::Exceptions::InvalidAttributeValueError.new("Attribute: #{name}, must not be nil.")
        end

        #check if the value being set is not of the specified type and should attempt to parse the value
        if !cka[:type].nil? && !value.nil? && (cka[:type] == :bool || !value.is_a?(cka[:type]))
          begin
            value = ClassKit::ValueHelper.instance.parse(type: cka[:type], value: value)
          rescue => e
            raise ClassKit::Exceptions::InvalidAttributeValueError.new("Attribute: #{name}, must be of type: #{cka[:type]}. Error: #{e}")
          end
        end

        instance_variable_set(:"@#{name}", value)
      end
    end
  end
end
