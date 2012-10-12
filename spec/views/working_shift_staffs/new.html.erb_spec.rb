require 'spec_helper'

describe "working_shift_staffs/new" do
  before(:each) do
    assign(:working_shift_staff, stub_model(WorkingShiftStaff,
      :user_id => 1,
      :working_shift_id => 1
    ).as_new_record)
  end

  it "renders new working_shift_staff form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => working_shift_staffs_path, :method => "post" do
      assert_select "input#working_shift_staff_user_id", :name => "working_shift_staff[user_id]"
      assert_select "input#working_shift_staff_working_shift_id", :name => "working_shift_staff[working_shift_id]"
    end
  end
end
