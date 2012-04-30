require 'spec_helper'

describe ArrivalFlight do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :flight_no => "VN5213",
      :flight_date => Date.today,
      :sta => DateTime.now
    }
  end
  
  describe "A authenticated user creates new arrival flight" do
    it "generate flight with flight number, assigned user_id, flight_date" do
      a_flight = @user.arrival_flights.create(@attr)
      a_flight.save
      a_flight.user_id.should == @user.id
      a_flight.flight_date.to_date.should == Date.today
      a_flight.flight_no.should_not be_nil
    end
  end
  
  describe "validations" do
    before(:each) do
      @flight = @user.arrival_flights.build(@attr)
    end
    
    it "should require a flight number" do
      @flight.flight_no = nil
      @flight.save
      @flight.should_not be_valid
    end
    
    it "should require flight date" do
      @flight.flight_date = nil
      @flight.save
      @flight.should_not be_valid
    end
    
    it "should require sta" do
      @flight.sta = nil
      @flight.save
      @flight.should_not be_valid
    end
  end
end
