module ClassKit
  class AttributeHelper
    # Get attributes for a given class
    #
    # @param klass [ClassKit] a class that has been extended with ClassKit
    #
    # @return [Hash]
    def get_attributes(klass)
      klass.class_variable_get(:@@class_kit_attributes).freeze
    end

    # Get attribute for a given class and name
    #
    # @param klass [ClassKit] a class that has been extended with ClassKit
    # @param name [Symbol] an attribute name
    #
    # @raise [ClassKit::Exceptions::AttributeNotFoundError] if the given attribute could not be found
    #
    # @return [Hash] that describes the attribute
    def get_attribute(klass:, name:)
      get_attributes(klass).detect { |i| i[:name] == name } ||
        raise(ClassKit::Exceptions::AttributeNotFoundError, "Attribute: #{name}, could not be found.")
    end

    # Get the type of a given attribute on a given class
    #
    # @param klass [ClassKit] a class that has been extended with ClassKit
    # @param name [Symbol]
    #
    # @return [Class]
    def get_attribute_type(klass:, name:)
      get_attribute(klass: klass, name: name)[:type]
    end
  end
end
