module ClassKit
  module CustomType
    def self.included(base)
      base.extend(CustomType)
    end

    # This method must return the parsed value when +from_hash+ is called
    def self.parse_from_hash(_value)
      raise NotImplementedError
    end

    # This method must return the parsed value when the class' attribute is assigned a value
    def self.parse_assign(_value)
      raise NotImplementedError
    end

    # This method must return the value that will be serialised for the attribute
    def to_hash_value
      raise NotImplementedError
    end
  end
end
