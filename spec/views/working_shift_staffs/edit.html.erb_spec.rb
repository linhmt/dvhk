require 'spec_helper'

describe "working_shift_staffs/edit" do
  before(:each) do
    @working_shift_staff = assign(:working_shift_staff, stub_model(WorkingShiftStaff,
      :user_id => 1,
      :working_shift_id => 1
    ))
  end

  it "renders the edit working_shift_staff form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => working_shift_staffs_path(@working_shift_staff), :method => "post" do
      assert_select "input#working_shift_staff_user_id", :name => "working_shift_staff[user_id]"
      assert_select "input#working_shift_staff_working_shift_id", :name => "working_shift_staff[working_shift_id]"
    end
  end
end
