require 'factory_girl'

FactoryGirl.define do
  factory :arrival_flight do
    flight_no "VN652"
    flight_date Date.today
    reg_no "326"
    routing_id 10
    user_id 1
    is_active true
    sta Time.now
  end
end