require 'spec_helper'

describe ArrivalFlight do
  before(:each) do
    @user = Factory(:user)
    @default_flight = Factory(:arrival_flight)
    @attr = {
      :flight_no => "VN1213",
      :flight_date => Date.today,
      :sta => DateTime.now,
      :eta => DateTime.now,
      :ata => DateTime.now,
      :ssr => "chuyen bay nhieu VIP/CIP",
      :is_active => true
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
  
  describe "generate outbound hash from Sabre text" do
    it "should parse string '7 01TAI/CHIH LIN...L...VN.811.SGN-REP.1135A..LHIKFD'" do
      outbound = "7 01TAI/CHIH LIN...L ...VN.811.SGN-REP.1135A..LHIKFD"
      outbound_array = ArrivalFlight.send(:parse_flight_outbound_line, outbound)
      outbound_array.should == "VN.811.SGN-REP.1135A"
    end
    
    it "should parse string '7 01TAI/CHIH LIN...L...0V8011.SGN-VCS.1135A..LHIKFD'" do
      outbound = "7 01TAI/CHIH LIN...L ...0V8011.SGN-VCS.1135A..LHIKFD"
      outbound_array = ArrivalFlight.send(:parse_flight_outbound_line, outbound)
      outbound_array.should == "0V8011.SGN-VCS.1135A"
    end
    
    it "should parse midnight flight '7 01TAI/CHIH LIN...L...VN.300.SGN-NRT.0005M..LHIKFD'" do
      outbound = "7 01TAI/CHIH LIN...L...VN.300.SGN-NRT.0005M..LHIKFD"
      outbound_array = ArrivalFlight.send(:parse_flight_outbound_line, outbound)
      outbound_array.should == "VN.300.SGN-NRT.0005M"
    end
    
    it "should parse '7 01TAI/CHIH LIN...L ...VN.811.SGN-RE...' to get correct name" do
      outbound = "7 01TAI/CHIH LIN...L ...VN.811.SGN-REP.1135A..LHIKFD"
      outbound_array = ArrivalFlight.send(:parse_name_outbound_line, outbound)
      outbound_array.should == "TAI/CHIH LIN"
    end
    
    it "should parse string to correct outbound flights" do
      ob_str = "<p>LO571/23AUGTPESGN-D&nbsp;&nbsp;&nbsp; <br />
TPESGN&nbsp;&nbsp;&nbsp; <br />
&nbsp; 1 01LIN/CHINCHIH...L ...VN.920.SGN-PNH..410P..KTCVUB&nbsp;&nbsp;&nbsp; <br />
&nbsp; 2 01LIU/CHUNTENG...L ...VN.920.SGN-PNH..410P..ONVWNZ&nbsp;&nbsp;&nbsp; <br />
&nbsp; 3 01PAN/CHIAYUMR...N ...VN.920.SGN-PNH..410P..DVDGWX&nbsp;&nbsp;&nbsp; <br />
&nbsp; 4 01TAI/WANJUNGM...N ...VN.920.SGN-PNH..410P..DVDGWX&nbsp;&nbsp;&nbsp; <br />
&nbsp; 5 01WANG/CHEN HS...L ...VN.920.SGN-PNH..410P..GZDJGP&nbsp;&nbsp;&nbsp; <br />
&nbsp; 6 01WU/WEICHIN M...L ...VN.920.SGN-PNH..410P..PPJLUD&nbsp;&nbsp;&nbsp; <br />
TOTAL&nbsp;&nbsp; 6&nbsp;&nbsp;&nbsp; <br />
&nbsp; 7 01TAI/CHIH LIN...L ...VN.811.SGN-REP.1135A..LHIKFD&nbsp;&nbsp;&nbsp; <br />
&nbsp; 8 01TSAI/HSINLIN...N ...VN.811.SGN-REP.1135A..JBVMIK&nbsp;&nbsp;&nbsp; <br />
TOTAL&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp; <br />
END</p>"
      outbound = @default_flight.process_outbound_text(ob_str)
      outbound.has_key?("VN.920").should == true
      outbound.fetch("VN.920").length == 4
      outbound.has_key?("VN.811").should == true
      outbound.fetch("VN.811").length == 2
    end
  end
end

