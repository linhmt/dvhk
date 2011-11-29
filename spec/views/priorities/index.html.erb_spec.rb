require 'spec_helper'

describe "priorities/index.html.erb" do
  before(:each) do
    assign(:priorities, [
      stub_model(Priority,
        :description => "Description",
        :pri_level => 1,
        :pri_name => "Pri Name"
      ),
      stub_model(Priority,
        :description => "Description",
        :pri_level => 1,
        :pri_name => "Pri Name"
      )
    ])
  end

  it "renders a list of priorities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Pri Name".to_s, :count => 2
  end
end
