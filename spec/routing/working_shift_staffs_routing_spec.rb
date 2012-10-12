require "spec_helper"

describe WorkingShiftStaffsController do
  describe "routing" do

    it "routes to #index" do
      get("/working_shift_staffs").should route_to("working_shift_staffs#index")
    end

    it "routes to #new" do
      get("/working_shift_staffs/new").should route_to("working_shift_staffs#new")
    end

    it "routes to #show" do
      get("/working_shift_staffs/1").should route_to("working_shift_staffs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/working_shift_staffs/1/edit").should route_to("working_shift_staffs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/working_shift_staffs").should route_to("working_shift_staffs#create")
    end

    it "routes to #update" do
      put("/working_shift_staffs/1").should route_to("working_shift_staffs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/working_shift_staffs/1").should route_to("working_shift_staffs#destroy", :id => "1")
    end

  end
end
