Feature: greeter says hello
  In order to start learning RSpec and Cucumber
  to say greeting
  
  Scenario: greeter says hello
  Given a greeter
  When I send it a message
  Then I should see "Hello Cucumber"
  