require 'spec_helper'
RSpec.describe ClassKit::AttributeHelper do
  describe '#get_attributes' do
    context 'when a class has NO polymorphism chain' do
      it 'should return all ClassKit attributes' do
        results = subject.get_attributes(TestAddress)
        expect(results.length).to eq(3)
      end
    end
    context 'when a class DOES have a polymorphism chain' do
      it 'should return all ClassKit attributes' do
        results = subject.get_attributes(TestChild)
        expect(results.length).to eq(4)
      end
    end
  end
  describe '#get_attribute' do
    context 'when a class has NO polymorphism chain' do
      it 'should return the ClassKit attribute by name' do
        attribute = subject.get_attribute(klass: TestAddress, name: :line1)
        expect(attribute).not_to be_nil
        expect(attribute[:name]).to eq(:line1)
      end
    end
    context 'when a class DOES have a polymorphism chain' do
      it 'should return the ClassKit attribute by name' do
        attribute = subject.get_attribute(klass: TestChild, name: :child1)
        expect(attribute).not_to be_nil
        expect(attribute[:name]).to eq(:child1)
      end
    end
  end
  describe '#get_attribute_type' do
    context 'when a class has NO polymorphism chain' do
      it 'should return the type of the ClassKit attribute' do
        type = subject.get_attribute_type(klass: TestAddress, name: :line1)
        expect(type).to eq(String)
      end
    end
    context 'when a class DOES have a polymorphism chain' do
      it 'should return the type of the ClassKit attribute' do
        type = subject.get_attribute_type(klass: TestChild, name: :child1)
        expect(type).to eq(String)
      end
    end
  end
end