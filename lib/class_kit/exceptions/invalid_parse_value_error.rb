module ClassKit
  module Exceptions
    class InvalidParseValueError < StandardError
      def initialize(message = 'Invalid parse value specified.')
        super
      end
    end
  end
end