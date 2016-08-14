require 'spec_helper'
RSpec.describe ClassKit::AttributeHelper do
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
end