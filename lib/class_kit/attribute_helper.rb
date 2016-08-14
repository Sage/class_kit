module ClassKit
  class AttributeHelper
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
  end
end