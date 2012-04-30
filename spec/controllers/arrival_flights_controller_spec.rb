require 'spec_helper'
describe ArrivalFlightsController do
  #  render_views
  describe "GET 'index'" do
    it "should display list of flights" do
      get :index
      response.should be_success
    end
  end
  
  describe "POST create" do
    let(:arrival) {mock_model(ArrivalFlight).as_null_object}
    before(:each) do
      @user = test_sign_in(Factory(:user))
      ArrivalFlight.stub(:new).and_return(arrival)
    end
  
    it "should create a new flight" do
      ArrivalFlight.should_receive(:new).and_return(arrival)
      post :create, :arrival_flight => {"flight_no" => "VN1205"}
    end
    
    it "saves new flight" do
      arrival.should_receive(:save)
      post :create
    end
    
    context "when the flight save succesfully," do
      before do
        arrival.stub(:save).and_return(true)
      end

      it "set flash[:notice] message" do
        post :create
        flash[:notice].should eq("The flight was saved succesfully.")
      end
      
      it "redirect to Arrival Flight index" do
        post :create
        response.should redirect_to(:action => "index")
      end
    end
    
    context "when the flight fails to save," do
      before do
        arrival.stub(:save).and_return(false)
      end
      it "assigns @arrival" do
        post :create
        assigns[:arrival].should eq(arrival)
      end
      
      it "renders new template" do
        post :create
        response.should render_template("new")
      end
    end
  end
end
