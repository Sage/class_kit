module ClassKit
  module Exceptions
    class InvalidAttributeValueError < StandardError
      def initialize(message = 'Invalid attribute value specified.')
        super
      end
    end
  end
end