require 'spec_helper'

describe "working_shift_staffs/show" do
  before(:each) do
    @working_shift_staff = assign(:working_shift_staff, stub_model(WorkingShiftStaff,
      :user_id => 1,
      :working_shift_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
