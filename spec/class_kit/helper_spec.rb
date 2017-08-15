require 'spec_helper'

RSpec.describe ClassKit::Helper do
  describe '#validate_class_kit' do
    context 'when a class implements ClassKit is specified' do
      it 'should return true' do
        expect(subject.validate_class_kit(TestAddress)).to be true
      end
    end
    context 'when a class does NOT implement ClassKit is specified' do
      it 'should raise error' do
        expect{ subject.validate_class_kit(String) }.to raise_error(ClassKit::Exceptions::InvalidClassError)
      end
    end
  end

  describe '#to_hash' do
    context 'when a valid class is specified' do
      let(:entity) do
        TestAddress.new.tap do |e|
          e.line1 = 'line1'
          e.line2 = 'line2'
          e.postcode = 'ne1 8rt'
        end
      end
      it 'should return a hash' do
        hash = subject.to_hash(entity)
        expect(hash).to be_a(Hash)
        expect(hash[:line1]).to eq(entity.line1)
        expect(hash[:line2]).to eq(entity.line2)
        expect(hash[:postcode]).to eq(entity.postcode)
      end
    end

    context 'when an invalid class is specified' do
      let(:entity) do
        InvalidClass.new.tap do |e|
          e.text = 'abc'
        end
      end
      it 'should raise error' do
        expect{ subject.to_hash(entity) }.to raise_error(ClassKit::Exceptions::InvalidClassError)
      end
    end

    context 'when defaults are used' do
      let(:now) { Time.now }
      let(:test_entity) do
        now
        t = TestWithDefaults.new
        t.age = 18
        t
      end
      let(:expected_attributes) { [:age, :name, :created_at, :variable_set_in_initializer] }

      context 'when we call the defaulted attributes first' do
        it 'default values are returned' do
          # call the default attributes
          test_entity.name
          test_entity.created_at
          expect(subject.to_hash(test_entity).keys).to match_array(expected_attributes)
        end
      end

      context 'when we dont call the defaulted attributes' do
        it 'default values are returned' do
          expect(subject.to_hash(test_entity).keys).to match_array(expected_attributes)
        end
      end

      describe 'Default timestamps' do
        it 'should generate the default timestamp when the class is instantiated and not when the method is called' do
          sleep(2)
          expect(subject.to_hash(test_entity)[:created_at].to_i).to be_within(now.to_i + 1).of(now.to_i)
        end
      end
    end
  end

  describe '#from_hash' do
    let(:hash) do
      {
          string: 'ABC',
          int: '5',
          address: {
              line1: 'street 1',
              line2: 'street 2',
              postcode: 'ne3 6rt'
          },
          address_collection: [
                                  {
                                      line1: 'a street 1',
                                      line2: 'a street 2',
                                      postcode: 'a ne3 6rt'
                                  },
                                  {
                                      line1: 'b street 1',
                                      line2: 'b street 2',
                                      postcode: 'b ne3 6rt'
                                  }
                  ]
      }
    end
    context 'when a valid hash is specified' do
      it 'should convert the hash' do
        entity = subject.from_hash(hash: hash, klass: TestEntity)
        expect(entity).not_to be_nil
        expect(entity.string).to eq(hash[:string])
        expect(entity.int).to eq(5)
        expect(entity.address).to be_a(TestAddress)
        expect(entity.address.line1).to eq(hash[:address][:line1])
        expect(entity.address.line2).to eq(hash[:address][:line2])
        expect(entity.address.postcode).to eq(hash[:address][:postcode])
        expect(entity.address_collection).to be_a(Array)
        expect(entity.address_collection.length).to eq(2)
        expect(entity.address_collection[0].line1).to eq(hash[:address_collection][0][:line1])
        expect(entity.address_collection[0].line2).to eq(hash[:address_collection][0][:line2])
        expect(entity.address_collection[0].postcode).to eq(hash[:address_collection][0][:postcode])
        expect(entity.address_collection[1].line1).to eq(hash[:address_collection][1][:line1])
        expect(entity.address_collection[1].line2).to eq(hash[:address_collection][1][:line2])
        expect(entity.address_collection[1].postcode).to eq(hash[:address_collection][1][:postcode])
      end
    end
    context 'when a valid hash is specified with nil attributes' do
      it 'should convert the hash' do
        entity = subject.from_hash(hash: {}, klass: TestEntity)
        expect(entity).not_to be nil
        expect(entity.string).to be nil
        expect(entity.int).to eq(10)
        expect(entity.address).to be nil
        expect(entity.address_collection).to be_a(Array)
        expect(entity.address_collection.length).to eq(0)
      end
    end
  end

  describe '#to_json' do
    let(:address) do
      TestAddress.new.tap do |a|
        a.line1 = 'street 1'
        a.line2 = 'street 2'
        a.postcode = 'ne3 5rt'
      end
    end
    let(:date) { Date.parse('01-Mar-2016') }
    let(:date_time) { DateTime.parse('01-Mar-2016 11:00') }
    let(:time) { Time.parse('01-Mar-2016 11:00') }
    let(:entity) do
      TestEntity.new.tap do |e|
        e.string = 'ABC'
        e.int = 5
        e.date = date
        e.datetime = date_time
        e.time = time
        e.bool = true
        e.address = address
        e.address_collection << address
        e.address_collection << address
      end
    end
    let(:hash) do
      {
          int: 5,
          date: date,
          datetime: date_time,
          time: time,
          string: 'ABC',
          bool: true,
          address: {
              line1: 'street 1',
              line2: 'street 2',
              postcode: 'ne3 5rt'
          },
          address_collection: [
                      {
                          line1: 'street 1',
                          line2: 'street 2',
                          postcode: 'ne3 5rt'
                      },
                      {
                          line1: 'street 1',
                          line2: 'street 2',
                          postcode: 'ne3 5rt'
                      }
                  ]
      }
    end

    it 'should convert the class to json' do
      result = subject.to_json(entity)
      expect(result).to be_a(String)
      # Parsing everything to json to make the test easier to read if it fails.
      expect(JSON.parse(result)).to eq(JSON.parse(JSON.dump(hash)))
    end
  end

  describe '#from_json' do
    let(:date) { Date.parse('01-Mar-2016') }
    let(:date_time) { DateTime.parse('01-Mar-2016 11:00') }
    let(:time) { Time.parse('01-Mar-2016 11:00') }
    let(:hash) do
      {
          int: 5,
          date: date,
          datetime: date_time,
          time: time,
          string: 'ABC',
          bool: true,
          address: {
              line1: 'street 1',
              line2: 'street 2',
              postcode: 'ne3 5rt'
          },
          address_collection: [
                   {
                       line1: 'a street 1',
                       line2: 'a street 2',
                       postcode: 'a ne3 5rt'
                   },
                   {
                       line1: 'b street 1',
                       line2: 'b street 2',
                       postcode: 'b ne3 5rt'
                   }
               ]
      }
    end
    let(:json) { JSON.dump(hash) }

    it 'should convert json into the relevant entity' do
      entity = subject.from_json(json: json, klass: TestEntity)
      expect(entity).to be_a(TestEntity)
      expect(entity.int).to eq(hash[:int])
      expect(entity.string).to eq(hash[:string])
      expect(entity.date).to eq(hash[:date])
      expect(entity.datetime).to eq(hash[:datetime])
      expect(entity.time).to eq(hash[:time])
      expect(entity.string).to eq(hash[:string])
      expect(entity.bool).to eq(hash[:bool])
      expect(entity.address).to be_a(TestAddress)
      expect(entity.address.line1).to eq(hash[:address][:line1])
      expect(entity.address.line2).to eq(hash[:address][:line2])
      expect(entity.address.postcode).to eq(hash[:address][:postcode])
      expect(entity.address_collection).to be_a(Array)
      expect(entity.address_collection.length).to eq(2)
      expect(entity.address_collection[0].line1).to eq(hash[:address_collection][0][:line1])
      expect(entity.address_collection[0].line2).to eq(hash[:address_collection][0][:line2])
      expect(entity.address_collection[0].postcode).to eq(hash[:address_collection][0][:postcode])
      expect(entity.address_collection[1].line1).to eq(hash[:address_collection][1][:line1])
      expect(entity.address_collection[1].line2).to eq(hash[:address_collection][1][:line2])
      expect(entity.address_collection[1].postcode).to eq(hash[:address_collection][1][:postcode])
    end
  end
end
