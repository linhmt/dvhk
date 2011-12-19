require 'spec_helper'

describe BriefingpostsController do
  render_views
  
  describe "GET 'index'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    
    it "should show briefingposts" do
      mp1 = Factory(:briefingpost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:briefingpost, :user => @user, :content => "Baz quux")
      get :index
      response.should have_selector("a.content", :content => mp1.content)
      response.should have_selector("a.content", :content => mp2.content)
    end
  end
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
  
    describe "failure" do
      
      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a briefingpost" do
        lambda do
          post :create, :briefingpost => @attr
        end.should_not change(Briefingpost, :count)
      end

      it "should render the new post" do
        post :create, :briefingpost => @attr
        response.should redirect_to(new_briefingpost_path)
      end
    end
  
    describe "success" do
      
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end
      
      it "should create a briefingpost" do
        lambda do
          post :create, :briefingpost => @attr
        end.should change(Briefingpost, :count).by(1)
      end
      
      it "should redirect to the home page" do
        post :create, :briefingpost => @attr
        response.should redirect_to(briefingposts_path)
      end
    end
  end
end