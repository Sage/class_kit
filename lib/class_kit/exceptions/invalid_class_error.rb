module ClassKit
  module Exceptions
    class InvalidClassError < StandardError
      def initialize(message = 'Invalid class.')
        super
      end
    end
  end
end