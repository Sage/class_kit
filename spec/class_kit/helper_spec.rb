require 'spec_helper'
RSpec.describe ClassKit::Helper do
  describe '#get_attributes' do
    it 'should return all ClassKit attributes' do
      results = subject.get_attributes(TestAddress)
      expect(results.length).to eq(3)
    end
  end
  describe '#get_attribute' do
    it 'should return the ClassKit attribute by name' do
      attribute = subject.get_attribute(klass: TestAddress, name: :line1)
      expect(attribute).not_to be_nil
      expect(attribute[:name]).to eq(:line1)
    end
  end
  describe '#get_attribute_type' do
    it 'should return the type of the ClassKit attribute' do
      type = subject.get_attribute_type(klass: TestAddress, name: :line1)
      expect(type).to eq(String)
    end
  end

  describe '#validate_class' do
    context 'when a class implements ClassKit is specified' do
      it 'should return true' do
        expect(subject.validate_class(TestAddress)).to be true
      end
    end
    context 'when a class does NOT implement ClassKit is specified' do
      it 'should raise error' do
        expect{ subject.validate_class(String) }.to raise_error(ClassKit::Exceptions::InvalidClassError)
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
  end
end