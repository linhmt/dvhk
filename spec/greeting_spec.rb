describe "Rspec Greeter" do
  it "should say 'Hello RSpec!' when it receives the greet() message" do
    greeter = RSpecGreeting.new
    greeting = greeter.greet
    greeting.should == "Hello RSpec!"
  end 
end