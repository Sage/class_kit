require 'spec_helper'
RSpec.describe ClassKit::ValueHelper do
  describe '#parse' do
    context 'when type: is Time' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: Time, value: '12-Mar-2016 11:00')
            expect(value).to be_a(Time)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'Integer' do
          let(:time) { Time.parse('12-Mar-2016 11:00').to_i }
          it 'should parse the value' do
            value = subject.parse(type: Time, value: time)
            expect(value).to be_a(Time)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'Float' do
          let(:time) { Time.parse('12-Mar-2016 11:00').to_f }
          it 'should parse the value' do
            value = subject.parse(type: Time, value: time)
            expect(value).to be_a(Time)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'Time' do
          let(:time) { Time.now }
          it 'should set the value to the time' do
            value = subject.parse(type: Time, value: time)
            expect(value).to be_a(Time)
            expect(value).to eq(time)
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Time, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is Date' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: Date, value: '12-Mar-2016')
            expect(value).to be_a(Date)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
          end
        end
        context 'Date' do
          let(:date) { Date.today }
          it 'should set the value to the time' do
            value = subject.parse(type: Date, value: date)
            expect(value).to be_a(Date)
            expect(value).to eq(date)
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Date, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is DateTime' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: DateTime, value: '12-Mar-2016 11:00')
            expect(value).to be_a(DateTime)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'Integer' do
          let(:date_time) { Time.parse('12-Mar-2016 11:00').to_i }
          it 'should parse the value' do
            value = subject.parse(type: Time, value: date_time)
            expect(value).to be_a(Time)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'Float' do
          let(:date_time) { Time.parse('12-Mar-2016 11:00').to_f }
          it 'should parse the value' do
            value = subject.parse(type: Time, value: date_time)
            expect(value).to be_a(Time)
            expect(value.year).to be 2016
            expect(value.month).to be 3
            expect(value.day).to be 12
            expect(value.hour).to be 11
            expect(value.min).to be 0
            expect(value.sec).to be 0
          end
        end
        context 'DateTime' do
          let(:date_time) { DateTime.now }
          it 'should set the value to the time' do
            value = subject.parse(type: DateTime, value: date_time)
            expect(value).to be_a(DateTime)
            expect(value).to eq(date_time)
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: DateTime, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is :bool' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: :bool, value: 'true')
            expect(value).to be_a(TrueClass)
            expect(value).to be true

            value = subject.parse(type: :bool, value: 'false')
            expect(value).to be_a(FalseClass)
            expect(value).to be false
          end
        end
        context 'TrueClass' do
          let(:bool) { true }
          it 'should set the value to the time' do
            value = subject.parse(type: :bool, value: bool)
            expect(value).to be_a(TrueClass)
            expect(value).to eq(bool)
          end
        end
        context 'FalseClass' do
          let(:bool) { false }
          it 'should set the value to the time' do
            value = subject.parse(type: :bool, value: bool)
            expect(value).to be_a(FalseClass)
            expect(value).to eq(bool)
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: :bool, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is Integer' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: Integer, value: '5')
            expect(value).to be_a(Integer)
            expect(value).to be 5
          end
        end
        context 'Integer' do
          it 'should parse the value' do
            value = subject.parse(type: Integer, value: 5)
            expect(value).to be_a(Integer)
            expect(value).to be 5
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Integer, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is Float' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: Float, value: '0.05')
            expect(value).to be_a(Float)
            expect(value).to be 0.05
          end
        end
        context 'Integer' do
          it 'should parse the value' do
            value = subject.parse(type: Float, value: 0.05)
            expect(value).to be_a(Float)
            expect(value).to be 0.05
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Float, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is BigDecimal' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: BigDecimal, value: '0.005')
            expect(value).to be_a(BigDecimal)
            expect(value).to eq BigDecimal('0.005')
          end

          it 'should parse a negative value' do
            value = subject.parse(type: BigDecimal, value: '-0.005')
            expect(value).to be_a(BigDecimal)
            expect(value).to eq BigDecimal('-0.005')
          end
        end
        context 'BigDecimal' do
          it 'should parse the value' do
            value = subject.parse(type: BigDecimal, value: 0.005)
            expect(value).to be_a(BigDecimal)
            expect(value).to eq BigDecimal.new('0.005')
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: BigDecimal, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is String' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: String, value: 'ABC')
            expect(value).to be_a(String)
            expect(value).to eq 'ABC'
          end
        end
        context 'Integer' do
          it 'should parse the value' do
            value = subject.parse(type: String, value: 5)
            expect(value).to be_a(String)
            expect(value).to eq '5'
          end
        end
      end
    end
    context 'when type: is Regexp' do
      context 'and value is a valid' do
        context 'String' do
          it 'should parse the value' do
            value = subject.parse(type: Regexp, value: '[\w\s]+')
            expect(value).to be_a(Regexp)
            expect(value).to eq /[\w\s]+/
          end
        end
        context 'Regexp' do
          it 'should parse the value' do
            value = subject.parse(type: Regexp, value: /[\w\s]+/)
            expect(value).to be_a(Regexp)
            expect(value).to eq /[\w\s]+/
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Regexp, value: TestEntity.new) }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is Hash' do
      context 'and value is a valid' do
        context 'Hash' do
          it 'should parse the value' do
            value = subject.parse(type: Hash, value: { key1: 'value1' })
            expect(value).to be_a(Hash)
            expect(value).to eq({ key1: 'value1' })
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Hash, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
    context 'when type: is Array' do
      context 'and value is a valid' do
        context 'Hash' do
          it 'should parse the value' do
            value = subject.parse(type: Array, value: ['item1', 'item2'])
            expect(value).to be_a(Array)
            expect(value).to eq(['item1', 'item2'])
          end
        end
      end
      context 'and value is NOT valid' do
        it 'should raise a invalid parse value error' do
          expect{ subject.parse(type: Array, value: 'ABC') }.to raise_error(ClassKit::Exceptions::InvalidParseValueError)
        end
      end
    end
  end

  describe '#instance' do
    it 'should return an instance of the ValueHelper' do
      helper1 = described_class.instance
      expect(helper1).to be_a(described_class)

      helper2 = described_class.instance
      expect(helper2).to eq(helper1)
    end
  end
end
