require 'spec_helper'

describe "priorities/show.html.erb" do
  before(:each) do
    @priority = assign(:priority, stub_model(Priority,
      :description => "Description",
      :pri_level => 1,
      :pri_name => "Pri Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Pri Name/)
  end
end
