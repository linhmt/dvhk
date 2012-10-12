require 'spec_helper'

describe "working_shift_staffs/index" do
  before(:each) do
    assign(:working_shift_staffs, [
      stub_model(WorkingShiftStaff,
        :user_id => 1,
        :working_shift_id => 2
      ),
      stub_model(WorkingShiftStaff,
        :user_id => 1,
        :working_shift_id => 2
      )
    ])
  end

  it "renders a list of working_shift_staffs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
