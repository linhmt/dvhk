require 'spec_helper'

describe "priorities/edit.html.erb" do
  before(:each) do
    @priority = assign(:priority, stub_model(Priority,
      :description => "MyString",
      :pri_level => 1,
      :pri_name => "MyString"
    ))
  end

  it "renders the edit priority form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => priorities_path(@priority), :method => "post" do
      assert_select "input#priority_description", :name => "priority[description]"
      assert_select "input#priority_pri_level", :name => "priority[pri_level]"
      assert_select "input#priority_pri_name", :name => "priority[pri_name]"
    end
  end
end
