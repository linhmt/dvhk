class UserMailer < ActionMailer::Base
  default from: "admin@sgsoftechnology.com"
  
  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/"
    mail(:to => user.email, :subject => "Welcome to TOC Flight Management")
  end
  
  def disapproval_arrival_flights(arrival_flights)
    @url  = "http://10.98.25.200:3001/"
    @arrival_flights = arrival_flights
    email_add = @arrival_flights.first.user.email
    mail(:to => email_add, :subject => "Arrival Flight Documents Correction Request!")
  end
end
