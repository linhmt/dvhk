require 'spec_helper'

describe Priority do
  before(:each) do
    @attr = {:pri_level => 1,
      :pri_name => "Positioning",
      :description => 'Crew team'
    }
  end
  
  it "should create a new instance given valid attributes" do
    Priority.create!(@attr)
  end
end
