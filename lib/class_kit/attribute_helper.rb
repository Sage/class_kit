module ClassKit
  class AttributeHelper

    def self.instance
      @instance ||= ClassKit::AttributeHelper.new
    end

    # Get attributes for a given class
    #
    # @param klass [ClassKit] a class that has been extended with ClassKit
    #
    # @return [Hash]
    def get_attributes(klass)
      attributes = []
      klass.ancestors.map do |k|
        hash = k.instance_variable_get(:@class_kit_attributes)
        if hash != nil
          hash.values.each do |a|
            attributes.push(a)
          end
        end
      end
      attributes.compact
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
      get_attributes(klass).detect { |a| a[:name] == name } ||
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
