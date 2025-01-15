module ClassKit
  def attr_accessor_type(
    name,
    type: nil,
    collection_type: nil,
    one_of: nil,
    allow_nil: true,
    default: nil,
    auto_init: false,
    alias_name: nil,
    meta: {})
    unless instance_variable_defined?(:@class_kit_attributes)
      instance_variable_set(:@class_kit_attributes, {})
    end

    attributes = instance_variable_get(:@class_kit_attributes)

    attributes[name] = {
      name: name,
      type: type,
      one_of: one_of,
      collection_type: collection_type,
      allow_nil: allow_nil,
      default: default,
      auto_init: auto_init,
      alias: alias_name,
      meta: meta
    }

    class_eval do
      define_method name do

        cka = ClassKit::AttributeHelper.instance.get_attribute(klass: self.class, name: name)

        current_value = instance_variable_get(:"@#{name}")

        if current_value.nil?
          if !cka[:default].nil?
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
        # get the attribute meta data
        cka = ClassKit::AttributeHelper.instance.get_attribute(klass: self.class, name: name)

        # verify if the attribute is allowed to be set to nil
        if value.nil? && cka[:allow_nil] == false
          raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must not be nil."
        end

        if !cka[:one_of].nil? && !value.nil?
          parsed_value =
          if value == true || value == false
            value
          elsif(/(true|t|yes|y|1)$/i === value.to_s.downcase)
            true
          elsif (/(false|f|no|n|0)$/i === value.to_s.downcase)
            false
          end

          if parsed_value != nil
            value = parsed_value
          else
            begin
              type = cka[:one_of].detect {|t| value.is_a?(t) }
              value = ClassKit::ValueHelper.instance.parse(type: type, value: value)
            rescue => e
              raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must be of type: #{type}. Error: #{e}"
            end
          end
        end

        if !cka[:type].nil? && !value.nil? && (cka[:type] == :bool || !value.is_a?(cka[:type]))
          begin
            value = ClassKit::ValueHelper.instance.parse(type: cka[:type], value: value)
          rescue => e
            raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must be of type: #{cka[:type]}. Error: #{e}"
          end
        end

        instance_variable_set(:"@#{name}", value)
      end
    end
  end
end
