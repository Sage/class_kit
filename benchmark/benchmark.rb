require_relative '../lib/class_kit'
require 'date'
require 'benchmark'

class Item
  extend ClassKit

  attr_accessor_type :text, type: String
  attr_accessor_type :integer, type: Integer
  attr_accessor_type :float, type: Float
  attr_accessor_type :date, type: Date
  attr_accessor_type :time, type: Time
  attr_accessor_type :bool, type: :bool
end

items = []
10_000.times do
  items << Item.new.tap do |e|
    e.text = 'foo bar'
    e.integer = 50
    e.float = 25.2
    e.date = Date.today
    e.time = Time.now
    e.bool = true
  end
end

helper = ClassKit::Helper.new

json = ''

puts '***serialize items***'
puts Benchmark.measure { json = helper.to_json(items) }

puts '***deserialize items***'
puts Benchmark.measure { helper.from_json(json: json, klass: Item) }
