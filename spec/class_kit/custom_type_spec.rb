require 'spec_helper'
RSpec.describe ClassKit::CustomType do
  describe 'the module methods' do
    it 'should raise a NotImplementedError when called directly' do
      expect { subject.parse_assign(nil) }.to raise_error(NotImplementedError)
      expect { subject.parse_from_hash(nil) }.to raise_error(NotImplementedError)
      expect { Class.new.extend(subject).to_hash_value }.to raise_error(NotImplementedError)
    end
  end
end
