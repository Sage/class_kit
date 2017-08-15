require 'spec_helper'
RSpec.describe ClassKit do

  let(:test_entity) do
    TestEntity.new
  end

  let(:child_entity) do
    TestParent.new
  end

  let(:empty_child_entity) do
    TestEmptyChild.new
  end

  it 'should have an instance variable for each default to allow .to_hash to work' do
    t = TestWithDefaults.new
    expect(t.instance_variables).to match_array([:@name, :@created_at])
  end

  context 'when setting the value of a base class attribute' do
    it 'should not error' do
      child_entity.base1 = 'hello world'
    end
  end

  context 'when a child entity is empty' do
    it 'class_kit_attributes are avaiable' do
      expect{ empty_child_entity.base1 }.not_to raise_error
    end
  end

  describe '#attr_accessor_type' do
    it 'should create the attribute' do
      expect(test_entity.respond_to?(:int)).to be true
    end

    context 'when attribute is nil' do
      it 'should return the default value if specified' do
        expect(test_entity.int).to be 10
      end
    end
    context 'when an attribute is NOT allowed to be nil' do
      context 'when attempting to set the value to nil' do
        it 'should raise an invalid attribute value error' do
          expect{ test_entity.int = nil }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
        end
      end
    end
    context 'when an attribute is allowed to be nil' do
      it 'should not raise an error when setting to nil' do
        expect{ test_entity.int_nil = nil }.not_to raise_error
        expect(test_entity.int_nil).to be nil
      end
    end

    context 'Integer type attribute' do
      context 'when setting the attribute value' do
        context 'from an int' do
          it 'should set the value' do
            expect{ test_entity.int = 20 }.not_to raise_error
            expect(test_entity.int).to eq(20)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            it 'should parse and set the value' do
              expect{ test_entity.int = '20' }.not_to raise_error
              expect(test_entity.int).to eq(20)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.int = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'Float type attribute' do
      context 'when setting the attribute value' do
        context 'from an float' do
          it 'should set the value' do
            expect{ test_entity.float = 0.05 }.not_to raise_error
            expect(test_entity.float).to eq(0.05)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            it 'should parse and set the value' do
              expect{ test_entity.float = '0.05' }.not_to raise_error
              expect(test_entity.float).to eq(0.05)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.float = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'Date type attribute' do
      context 'when setting the attribute value' do
        context 'from a date' do
          let(:date) { Date.today }
          it 'should set the value' do
            expect{ test_entity.date = date }.not_to raise_error
            expect(test_entity.date).to eq(date)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            let(:date) { Date.today }
            it 'should parse and set the value' do
              expect{ test_entity.date = date.to_s }.not_to raise_error
              expect(test_entity.date).to eq(date)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.date = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'DateTime type attribute' do
      context 'when setting the attribute value' do
        context 'from a datetime' do
          let(:datetime) { DateTime.now }
          it 'should set the value' do
            expect{ test_entity.datetime = datetime }.not_to raise_error
            expect(test_entity.datetime).to eq(datetime)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            let(:datetime) { DateTime.now }
            it 'should parse and set the value' do
              expect{ test_entity.datetime = datetime.iso8601(9) }.not_to raise_error
              expect(test_entity.datetime).to eq(datetime)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.datetime = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'Time type attribute' do
      context 'when setting the attribute value' do
        context 'from a time' do
          let(:time) { Time.now }
          it 'should set the value' do
            expect{ test_entity.time = time }.not_to raise_error
            expect(test_entity.time).to eq(time)
          end
        end
        context 'from an integer' do
          let(:time) { Time.now }
          it 'should set the value' do
            expect{ test_entity.time = time.to_i }.not_to raise_error
            expect(test_entity.time.to_i).to eq(time.to_i)
          end
        end
        context 'from a float' do
          let(:time) { Time.now }
          it 'should set the value' do
            expect{ test_entity.time = time.to_f }.not_to raise_error
            expect(test_entity.time.to_f).to eq(time.to_f)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            let(:time) { Time.now }
            it 'should parse and set the value' do
              expect{ test_entity.time = time.iso8601(9) }.not_to raise_error
              expect(test_entity.time).to eq(time)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.time = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'String type attribute' do
      context 'when setting the attribute value' do
        context 'from an string' do
          it 'should set the value' do
            expect{ test_entity.string = 'ABC' }.not_to raise_error
            expect(test_entity.string).to eq('ABC')
          end
        end
      end
    end

    context ':bool type attribute' do
      context 'when setting the attribute value' do
        context 'from a bool' do
          it 'should set the value to true' do
            expect{ test_entity.bool = true }.not_to raise_error
            expect(test_entity.bool).to eq(true)
          end
          it 'should set the value to false' do
            expect{ test_entity.bool = false }.not_to raise_error
            expect(test_entity.bool).to eq(false)
          end
        end
        context 'from a string' do
          context 'that can be parsed' do
            it 'should parse and set the value to true' do
              expect{ test_entity.bool = 'true' }.not_to raise_error
              expect(test_entity.bool).to eq(true)
            end
            it 'should parse and set the value to false' do
              expect{ test_entity.bool = 'false' }.not_to raise_error
              expect(test_entity.bool).to eq(false)
            end
          end
          context 'that can NOT be parsed' do
            it 'should raise an error' do
              expect{ test_entity.bool = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
            end
          end
        end
      end
    end

    context 'attribute with no type specified' do
      context 'when NOT allowed to be nil' do
        context 'when attempting to set the value to nil' do
          it 'should raise an invalid attribute value error' do
            expect{ test_entity.any = nil }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
          end
        end
      end
      context 'when allowed to be nil' do
        it 'should not raise an error when setting to nil' do
          expect{ test_entity.any_nil = nil }.not_to raise_error
          expect(test_entity.any_nil).to be nil
        end
      end
      it 'should allow any value type to be specified' do
        expect{ test_entity.any = 'hello' }.not_to raise_error
        expect{ test_entity.any = 5 }.not_to raise_error
        expect{ test_entity.any = { hello: 'world' } }.not_to raise_error
      end
    end

    context 'Hash attribute specified' do
      context 'when setting the attribute value' do
        context 'from a Hash' do
          it 'should set the value' do
            expect{ test_entity.hash = { key1: 'value1' } }.not_to raise_error
          end
        end
        context 'from a String' do
          it 'should raise an error' do
            expect{ test_entity.hash = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
          end
        end
      end
    end

    context 'Array attribute specified' do
      context 'when setting the attribute value' do
        context 'from a Array' do
          it 'should set the value' do
            expect{ test_entity.array = ['value1', 'value2'] }.not_to raise_error
          end
        end
        context 'from a String' do
          it 'should raise an error' do
            expect{ test_entity.array = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
          end
        end
      end
    end

    context 'Class Type attribute specified' do
      context 'when setting the attribute value' do
        context 'from a TestAddress' do
          it 'should set the value' do
            expect{ test_entity.address = TestAddress.new }.not_to raise_error
          end
        end
        context 'from a String' do
          it 'should raise an error' do
            expect{ test_entity.address = 'ABC' }.to raise_error(ClassKit::Exceptions::InvalidAttributeValueError)
          end
        end
      end
      context 'when auto_init is true' do
        context 'and the attribute has not been set' do
          it 'should return a new instance of the attribute type' do
            expect(test_entity.address_auto).not_to be nil
            expect(test_entity.address_auto).to be_a(TestAddress)
          end
        end
      end
    end

  end
end
