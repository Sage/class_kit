require_relative '../lib/class_kit'
require 'date'
require 'benchmark'
require 'json'

# -------------------------------------------------------------------
# Test entities
# -------------------------------------------------------------------

class BenchContact
  extend ClassKit
  attr_accessor_type :landline, type: String
  attr_accessor_type :mobile, type: String
  attr_accessor_type :email, type: String
end

class BenchAddress
  extend ClassKit
  attr_accessor_type :line1, type: String
  attr_accessor_type :line2, type: String
  attr_accessor_type :postcode, type: String
  attr_accessor_type :country, type: String
end

class BenchEmployee
  extend ClassKit
  attr_accessor_type :name, type: String
  attr_accessor_type :age, type: Integer
  attr_accessor_type :salary, type: Float
  attr_accessor_type :dob, type: Date
  attr_accessor_type :active, type: :bool
  attr_accessor_type :address, type: BenchAddress
  attr_accessor_type :contacts, type: Array, collection_type: BenchContact
end

class BenchFlatItem
  extend ClassKit
  attr_accessor_type :text, type: String
  attr_accessor_type :integer, type: Integer
  attr_accessor_type :float, type: Float
  attr_accessor_type :date, type: Date
  attr_accessor_type :time, type: Time
  attr_accessor_type :bool, type: :bool
end

class BenchDeeplyNested
  extend ClassKit
  attr_accessor_type :name, type: String
  attr_accessor_type :child, type: BenchEmployee
  attr_accessor_type :employees, type: Array, collection_type: BenchEmployee
end

# -------------------------------------------------------------------
# Data builders
# -------------------------------------------------------------------

def build_flat_item
  BenchFlatItem.new.tap do |e|
    e.text = 'foo bar'
    e.integer = 50
    e.float = 25.2
    e.date = Date.today
    e.time = Time.now
    e.bool = true
  end
end

def build_address
  BenchAddress.new.tap do |a|
    a.line1 = '25 The Street'
    a.line2 = 'Home Town'
    a.postcode = 'NE3 5RT'
    a.country = 'United Kingdom'
  end
end

def build_contact
  BenchContact.new.tap do |c|
    c.landline = '01234567890'
    c.mobile = '07891234567'
    c.email = 'test@example.com'
  end
end

def build_employee
  BenchEmployee.new.tap do |e|
    e.name = 'Joe Bloggs'
    e.age = 42
    e.salary = 55_000.50
    e.dob = Date.parse('1980-06-03')
    e.active = true
    e.address = build_address
    e.contacts = [build_contact, build_contact]
  end
end

def build_deeply_nested
  BenchDeeplyNested.new.tap do |d|
    d.name = 'Root'
    d.child = build_employee
    d.employees = 5.times.map { build_employee }
  end
end

# -------------------------------------------------------------------
# Benchmark runner
# -------------------------------------------------------------------

ITERATIONS = 5
SIZES = { small: 100, medium: 1_000, large: 10_000 }

helper = ClassKit::Helper.new

def separator
  puts '-' * 70
end

def run_benchmark(label, iterations: ITERATIONS)
  times = iterations.times.map do
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0
  end
  median = times.sort[times.size / 2]
  best = times.min
  printf "  %-50s median: %8.4fs  best: %8.4fs\n", label, median, best
  median
end

puts '=' * 70
puts 'ClassKit Benchmark Suite'
puts "Ruby #{RUBY_VERSION} | #{RUBY_PLATFORM}"
puts '=' * 70

results = {}

# -------------------------------------------------------------------
# 1. Flat serialization (to_json / from_json)
# -------------------------------------------------------------------
puts "\n### 1. Flat items (6 typed attributes, no nesting)"
separator

SIZES.each do |size_name, count|
  items = count.times.map { build_flat_item }
  json = helper.to_json(items)

  key_ser = "flat_#{size_name}_serialize"
  key_de = "flat_#{size_name}_deserialize"

  results[key_ser] = run_benchmark("to_json   #{count} flat items") { helper.to_json(items) }
  results[key_de]  = run_benchmark("from_json #{count} flat items") do
    helper.from_json(json: json, klass: BenchFlatItem)
  end
end

# -------------------------------------------------------------------
# 2. Nested serialization (Employee with Address + Contacts)
# -------------------------------------------------------------------
puts "\n### 2. Nested items (Employee -> Address + 2x Contact)"
separator

SIZES.each do |size_name, count|
  items = count.times.map { build_employee }
  json = helper.to_json(items)

  key_ser = "nested_#{size_name}_serialize"
  key_de = "nested_#{size_name}_deserialize"

  results[key_ser] = run_benchmark("to_json   #{count} nested items") { helper.to_json(items) }
  results[key_de]  = run_benchmark("from_json #{count} nested items") do
    helper.from_json(json: json, klass: BenchEmployee)
  end
end

# -------------------------------------------------------------------
# 3. Deeply nested (3 levels deep with arrays)
# -------------------------------------------------------------------
puts "\n### 3. Deeply nested items (3 levels, arrays of nested)"
separator

[10, 100, 500].each do |count|
  items = count.times.map { build_deeply_nested }
  json = helper.to_json(items)

  key_ser = "deep_#{count}_serialize"
  key_de = "deep_#{count}_deserialize"

  results[key_ser] = run_benchmark("to_json   #{count} deep items") { helper.to_json(items) }
  results[key_de]  = run_benchmark("from_json #{count} deep items") do
    helper.from_json(json: json, klass: BenchDeeplyNested)
  end
end

# -------------------------------------------------------------------
# 4. Hash round-trip (no JSON overhead)
# -------------------------------------------------------------------
puts "\n### 4. Hash round-trip (to_hash / from_hash, 1000 nested)"
separator

items = 1_000.times.map { build_employee }
hashes = items.map { |i| helper.to_hash(i) }

results['hash_serialize']   = run_benchmark('to_hash   1000 nested items') { items.each { |i| helper.to_hash(i) } }
results['hash_deserialize'] = run_benchmark('from_hash 1000 nested items') do
  hashes.each do |h|
    helper.from_hash(hash: h, klass: BenchEmployee)
  end
end

# -------------------------------------------------------------------
# 5. Micro: single object round-trip
# -------------------------------------------------------------------
puts "\n### 5. Micro: single object (10_000 iterations)"
separator

employee = build_employee
employee_json = helper.to_json(employee)
employee_hash = helper.to_hash(employee)

results['micro_to_json'] = run_benchmark('to_json   single employee x10k') do
  10_000.times do
    helper.to_json(employee)
  end
end
results['micro_from_json'] = run_benchmark('from_json single employee x10k') do
  10_000.times do
    helper.from_json(json: employee_json, klass: BenchEmployee)
  end
end
results['micro_to_hash'] = run_benchmark('to_hash   single employee x10k') do
  10_000.times do
    helper.to_hash(employee)
  end
end
results['micro_from_hash'] = run_benchmark('from_hash single employee x10k') do
  10_000.times do
    helper.from_hash(hash: employee_hash, klass: BenchEmployee)
  end
end

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
puts "\n"
puts '=' * 70
puts 'Summary (median times in seconds)'
puts '=' * 70
results.sort_by { |_, v| -v }.each do |label, time|
  printf "  %-45s %8.4fs\n", label, time
end
