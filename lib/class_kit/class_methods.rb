module ClassKit
  def attr_accessor_type(name, type: nil, collection_type: nil, allow_nil: true, default: nil, auto_init: false,
                         meta: {})

    unless instance_variable_defined?(:@class_kit_attributes)
      instance_variable_set(:@class_kit_attributes, {})
    end

    attributes = instance_variable_get(:@class_kit_attributes)

    attributes[name] = { name: name, type: type, collection_type: collection_type, allow_nil: allow_nil,
                         default: default, auto_init: auto_init, meta: meta }

    class_eval do
      def self.new( *args, &blk)
        o = super # get the result of an existing initializer
        attributes = o.class.instance_variable_get('@class_kit_attributes')
        return o unless attributes

        # add any default attributes to instance variables unless they already have a value
        attributes.each_pair do |_, v|
          current_value = o.public_send(v[:name])
          # TODO: Do we want to allow nils to be serialized?
          unless current_value
            o.instance_variable_set( "@#{v[:name]}", v[:default]) if v[:default]
          end
        end
        o
      end

      define_method name do
        cka = ClassKit::AttributeHelper.instance.get_attribute(klass: self.class, name: name)

        current_value = instance_variable_get(:"@#{name}")

        if current_value.nil?
          if cka[:auto_init]
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

        # check if the value being set is not of the specified type and should attempt to parse the value
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
