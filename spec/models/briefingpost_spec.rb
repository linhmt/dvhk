require 'spec_helper'

describe Briefingpost do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :content => "Test briefingpost",
      :active_date => DateTime.now
    }
  end

  it "should create a new instance given valid attributes" do
    @user.briefingposts.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @post = @user.briefingposts.create(@attr)
    end

    it "should have a user attribute" do
      @post.should respond_to(:user)
    end

    it "should have the right associated user" do
      @post.user_id.should == @user.id
      @post.user.should == @user
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Briefingpost.new(@attr).should_not be_valid
    end

    it "should require content's length greater than 10" do
      @post = @user.briefingposts.build(@attr)
      @post.content = "abcd"
      @post.should_not be_valid
    end

    it "should reject long content" do
      @post = @user.briefingposts.build(@attr)
      @post.content = "a" * 501
      @post.should_not be_valid
    end
  end
end