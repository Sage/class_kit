module ClassKit
  module Exceptions
    class AttributeNotFoundError < StandardError
      def initialize(message = 'Attribute not found.')
        super
      end
    end
  end
end