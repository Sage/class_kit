# ClassKit

[![RSpec](https://github.com/Sage/class_kit/actions/workflows/rspec.yml/badge.svg)](https://github.com/Sage/class_kit/actions/workflows/rspec.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/0bc83e414eed8759a0e8/maintainability)](https://codeclimate.com/github/Sage/class_kit/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0bc83e414eed8759a0e8/test_coverage)](https://codeclimate.com/github/Sage/class_kit/test_coverage)
[![Gem Version](https://badge.fury.io/rb/class_kit.svg)](https://badge.fury.io/rb/class_kit)

Welcome to your ClassKit! ClassKit is a toolkit for working with entities & classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'class_kit'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install class_kit
```

## Usage

### Creating an entity

```ruby
class Contact
  extend ClassKit

  attr_accessor_type :landline, type: String
  attr_accessor_type :mobile, type: String
  attr_accessor_type :email, type: String
end

class Address
  extend ClassKit

  attr_accessor_type :line1, type: String
  attr_accessor_type :line2
  attr_accessor_type :postcode
end

class Employee
  extend ClassKit

  attr_accessor_type :name, type: String
  attr_accessor_type :dob, type: Date
  attr_accessor_type :address, type: Address, auto_init: true
  attr_accessor_type :contacts, type: Array, collection_type: Contact, auto_init: true
end
```

ClassKit entities can be created by implementing the `extend ClassKit` extend into the entity class and then using the `attr_accessor_type` method to register attributes as above inplace of the standard ruby `attr_accessor` method.

ClassKit entity attributes can use a name alias in order to parse to/from hashes/json with different key names, see the example below:

```ruby
class Address
  extend ClassKit

  attr_accessor_type :line1, type: String, alias_name: :l1
  attr_accessor_type :line2, alias_name: :l2
  attr_accessor_type :postcode, alias_name: :pc
end
```

```json
{ "l1": "23 the street", "l2": "the town", "pc": "ne1 4rt" }
```

To use alias names you must specify `use_alias = true` for the following helper methods:

```ruby
helper.to_hash(entity, true)
helper.from_hash(hash: hash_object, klass: entity_klass, use_alias: true)

helper.to_json(entity, true)
helper.from_json(json: json_string, klass: entity_klass, use_alias: true)
```

### attr_accessor_type

This method is used to add typed attributes to a class.

Supported standard types:

- String
- Integer
- Float
- BigDecimal
- Date
- DateTime
- Time
- :bool (true/false)
- Regexp

The above supported standard types will attempt to parse any values passed to the attribute if the value is not of the same type as the attribute.

Example:

```
entity.dob = '03-JUN-1980'
```

Would be parsed into a `Date` object and set to the attribute, so that subsequent calls to get the value from the attribute would return a `Date` object for the `entity.dob` value.

Attributes can have any type specified, they are not limited to the standard types listed above, however only the standard types listed above will attempt to parse non type matching values when setting the attribute value.

If an invalid value is passed to an attribute it will raise a `ClassKit::Exceptions::InvalidAttributeValueError` exception.

Attributes don't require the `type:` argument to be specified for attributes where type information is variable or not required.

#### Arrays

The `attr_accessor_type` method allows attributes of type `Array` to be specified, these attributes can also specify the `collection_type:` argument to specify what the type the elements of the Array will be.

#### Additional Arguments

The below are additional arguments that can be specified when using the `attr_accessor_type` method.

- `allow_nil:` This argument is used to specify if an attribute is allowed to have nil set as it's value.
- `auto_init:` This argument is used to specify an attribute should auto initialise it's value when nil. (Useful for Array's and Nested entities)
- `default:` This argument is used to specify a default value that the attribute should be set to when nil.
- `meta:` This argument is used to specify any additional meta information you want to attach to the attribute.

### ClassKit::Helper

This helper class provides several useful helper methods for working with ClassKit entities.

#### #is_class_kit?(object)

This method is called to determine if an object is a ClassKit entity or not.

[Params]
- `object` This is the object to check.

[Return]

`true` or `false`

Example:

```ruby
helper.is_class_kit?(obj)
```

#### #to_hash(object, use_alias)

This method is called to convert a ClassKit entity into a `Hash`.

[Params]
- `object` [Required] This is the ClassKit entity to convert.
- `use_alias` [Optional] [Default=false] This is used to specify if attribute alias names should be used.

[Return]

`Hash`

Example:

```ruby
hash = helper.to_hash(obj)
```

#### #from_hash(hash:,klass:, use_alias:)

This method is called to convert a `Hash` into a ClassKit entity.

[Params]
- `hash:` [Required] This is the `Hash` to convert.
- `klass:` [Required] This is the class of the ClassKit entity you want to convert the `Hash` into.
> NOTE: It should be the fully qualified class name including modules
- `use_alias` [Optional] [Default=false] This is used to specify if attribute alias names should be used.

[Return]

ClassKit entity.

Example:

```ruby
entity = helper.from_hash(hash: hsh, klass: Contact)
```

#### #to_json(object, use_alias)

This method is called to convert a ClassKit entity into JSON.

[Params]
- `object` This is the ClassKit entity to convert.
- `use_alias` [Optional] [Default=false] This is used to specify if attribute alias names should be used.

[Return]

JSON string.

Example:

```ruby
json_string = helper.to_json(obj)
```

#### #from_json(json:, klass:, use_alias:)

This method is called to convert a JSON string into a ClassKit entity.

[Params]
- `json:` This is the JSON string to convert.
- `klass:` This is the class of the ClassKit entity you want to convert the JSON into.
> NOTE: It should be the fully qualified class name including modules
- `use_alias` [Optional] [Default=false] This is used to specify if attribute alias names should be used.

[Return]

ClassKit entity.

Example:

```ruby
entity = helper.from_json(json: json_string, klass: Contact)
```

NOTE: This method will parse any nested Hashes that match attributes specified with a type: that is a ClassKit entity, as well as populating `Arrays` where the `collection_type:` has been specified as a ClassKit entity.

Example:

```json
{"name":"Joe Bloggs","dob":"03-JUNE-1980","address":{"line1":"25 The Street","line2":"Home Town","postcode":"NE3 5RT"},"contacts":[{"landline":"01235456789","mobile":"0789456123","email":"joe.bloggs@test.com"}]}
```

Would be parsed into the ClassKit `Employee` class defined above along with the nested `Address` attribute and `Contact` array.

Allowing the `Address` to be accessed via `entity.address.line1` etc and the `Contact` details to be accessed via `entity.contacts[0].landline` etc.


### ClassKit::AttributeHelper

This helper class provides several useful methods for accessing the attribute details for a ClassKit entity.

#### #get_attribute_type(klass:, name:)

This method is called to get the type of a specific attribute of a ClassKit entity.

[Params]
- `klass:` This is the ClassKit entity class that contains the attribute.
- `name:` This is the name of the attribute to get the type for.

[Return]

`Type`

#### #get_attribute(klass:, name:)

This method is called to get the details of a specific attribute of a ClassKit entity.

[Params]
- `klass:` This is the ClassKit entity class that contains the attribute.
- `name:` This is the name of the attribute to get the details for.

[Return]

`Hash` of `{ name:, type:, collection_type:, allow_nil:, default:, auto_init:, meta: }`

#### #get_attributes(klass)

This method is called to get an array of the Attribute details for a specified ClassKit entity.

[Params]
- `klass` This is the ClassKit entity class to get the attribute details for.

[Return]

`Array` of `{ name:, type:, collection_type:, allow_nil:, default:, auto_init:, meta: }`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sage/class_kit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

This gem is available as open source under the terms of the
[MIT licence](LICENSE).

Copyright (c) 2018 Sage Group Plc. All rights reserved.
