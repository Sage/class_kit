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
  end
end