require 'spec_helper'

describe "WorkingShiftStaffs" do
  describe "GET /working_shift_staffs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get working_shift_staffs_path
      response.status.should be(200)
    end
  end
end
