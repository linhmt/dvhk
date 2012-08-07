require 'spec_helper'

describe ArrivalFlight do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :flight_no => "VN1213",
      :flight_date => Date.today,
      :sta => DateTime.now,
      :eta => DateTime.now,
      :ata => DateTime.now,
      :ssr => "chuyen bay nhieu VIP/CIP"
    }
  end
  
  describe "A authenticated user creates new arrival flight" do
    it "generate flight with flight number, assigned user_id, flight_date" do
      a_flight = @user.arrival_flights.create(@attr)
      a_flight.save!
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
  
  describe "SSR" do
    it "should save ssr when updating" do
      a_flight = @user.arrival_flights.create(@attr)
      a_flight.ssr = "Chuyen bay nhieu VIP/CIP"
      a_flight.save
      a_flight.ssr.should == "Chuyen bay nhieu VIP/CIP"
    end
  end
  
  describe "baggage information" do
    it "should save baggage details when updating" do
      a_flight = @user.arrival_flights.create(@attr)
      a_flight.baggage = "AHL SGNVN12345"
      a_flight.save
      a_flight.baggage.should == "AHL SGNVN12345"
    end
  end
  
  describe "adjust arrival time" do
    it "should not do anything if eta arrnextday nil" do
      a_flight = @user.arrival_flights.create(@attr)
      time = a_flight.eta
      a_flight.eta
      a_flight.eta_arrnextday = nil
      a_flight.save!
      a_flight.eta.localtime.should == time
    end
    
    it "should adjust 1 day if arrnextday true" do
      a_flight = @user.arrival_flights.create(@attr)
      time = a_flight.eta
      a_flight.eta_arrnextday = "1"
      a_flight.save!
      a_flight.eta.should == time.advance(:days => 1)
    end
  end
end
