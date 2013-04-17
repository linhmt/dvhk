require 'spec_helper'

describe ShiftTracking do
  before(:each) do
    @valid_pos = FactoryGirl.build(:system_constant,
      :value => "valid_position",
      :name => ['PK1', 'GT1']
    )
  end
  
  describe "recognise if in-out time not meet the conditions" do
    it "should return correct value if reduced hour allowed" do
      ShiftTracking.invalid_hour("GT2", "-2.3") == -2.3
    end
  end
end
