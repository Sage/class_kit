class TestAddress
  extend ClassKit
  attr_accessor_type :line1, type: String
  attr_accessor_type :line2
  attr_accessor_type :postcode
end

class TestEntity
  extend ClassKit

  attr_accessor_type :int, type: Integer, default: 10, allow_nil: false
  attr_accessor_type :int_nil, type: Integer
  attr_accessor_type :any, allow_nil: false
  attr_accessor_type :any_nil
  attr_accessor_type :float, type: Float
  attr_accessor_type :string, type: String
  attr_accessor_type :date, type: Date
  attr_accessor_type :datetime, type: DateTime
  attr_accessor_type :time, type: Time
  attr_accessor_type :bool, type: :bool
  attr_accessor_type :hash, type: Hash
  attr_accessor_type :array, type: Array

  attr_accessor_type :address, type: TestAddress, allow_nil: false
  attr_accessor_type :address_auto, type: TestAddress, allow_nil: false, auto_init: true

  attr_accessor_type :address_collection, type: Array, collection_type: TestAddress, allow_nil: false, auto_init: true
end

class InvalidClass
  attr_accessor :text
end
class TestParent
  extend ClassKit
  attr_accessor_type :base1, type: String
  attr_accessor_type :base2
end
class TestChild < TestParent
  extend ClassKit
  attr_accessor_type :child1, type: String
  attr_accessor_type :child2
end
class TestChild2 < TestParent
  extend ClassKit
  attr_accessor_type :text, type: String
end
class TestChild3 < TestParent
  extend ClassKit
  attr_accessor_type :text1, type: String
  attr_accessor_type :text2, type: String
end

class TestEmptyChild < TestParent
  extend ClassKit
end
