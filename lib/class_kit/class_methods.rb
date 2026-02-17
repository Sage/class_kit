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
    meta: {}
  )
    instance_variable_set(:@class_kit_attributes, {}) unless instance_variable_defined?(:@class_kit_attributes)

    attributes = instance_variable_get(:@class_kit_attributes)

    getter = :"@#{name}"
    setter = :"#{name}="

    cka = {
      name: name,
      setter: setter,
      type: type,
      one_of: one_of,
      collection_type: collection_type,
      allow_nil: allow_nil,
      default: default,
      auto_init: auto_init,
      alias: alias_name,
      meta: meta
    }.freeze
    attributes[name] = cka

    value_helper = ClassKit::ValueHelper.instance

    # ========= Define attribute getter =========
    if !default.nil? || auto_init
      class_eval do
        define_method name do
          current_value = instance_variable_get(getter)

          if current_value.nil?
            if !cka[:default].nil?
              current_value = instance_variable_set(getter, cka[:default])
            elsif cka[:auto_init]
              current_value = instance_variable_set(getter, cka[:type].new)
            end
          end

          current_value
        end
      end
    else
      # no default or auto_init: just return the variable
      class_eval do
        define_method(name) do
          instance_variable_get(getter)
        end
      end
    end

    # ========= Define attribute setter =========
    # The methods are defined as lean as possible
    # This is a bit harder to read at this level but it gets rid of unnecessary runtime checks
    # 1. If one_of is specified, we check if the value matches any of the allowed types
    if one_of
      class_eval do
        define_method "#{name}=" do |value|
          if value.nil? && cka[:allow_nil] == false
            raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must not be nil."
          end

          value = if value.nil?
                    value
                  elsif [true, false].include?(value)
                    value
                  elsif Constants::BOOL_TRUE_RE.match?(value.to_s)
                    true
                  elsif Constants::BOOL_FALSE_RE.match?(value.to_s)
                    false
                  else
                    begin
                      t = cka[:one_of].detect { |t| value.is_a?(t) }
                      value = value_helper.parse(type: t, value: value)
                    rescue StandardError => e
                      raise ClassKit::Exceptions::InvalidAttributeValueError,
                            "Attribute: #{name}, must be of type: #{t}. Error: #{e}"
                    end
                  end

          instance_variable_set(getter, value)
        end
      end
    # 2. When the attribute is typed, we parse into the target type if needed
    elsif type
      class_eval do
        define_method "#{name}=" do |value|
          if value.nil?
            if cka[:allow_nil] == false
              raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must not be nil."
            end
          elsif type == :bool || !value.is_a?(type)
            begin
              value = value_helper.parse(type: type, value: value)
            rescue StandardError => e
              raise ClassKit::Exceptions::InvalidAttributeValueError,
                    "Attribute: #{name}, must be of type: #{type}. Error: #{e}"
            end
          end

          instance_variable_set(getter, value)
        end
      end
    # 3. If untyped and we allow nil, simply set the variable
    elsif allow_nil == true
      class_eval do
        define_method "#{name}=" do |value|
          instance_variable_set(getter, value)
        end
      end
    # 4. In all other cases, only set the variable if non-nil
    else
      class_eval do
        define_method "#{name}=" do |value|
          raise ClassKit::Exceptions::InvalidAttributeValueError, "Attribute: #{name}, must not be nil." if value.nil?

          instance_variable_set(getter, value)
        end
      end
    end
  end
end
