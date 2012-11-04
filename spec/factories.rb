require 'factory_girl'

FactoryGirl.define do 
  factory :user do
    name 'Test User Fullname'
    short_name 'Test User'
    email 'user@test.com'
    password 'please'
  end
end

FactoryGirl.define do
  factory :priority do
    pri.description 'PLATIUM VNA'
    pri.pri_level 1
    pri.pri_name 'PLA'
  end
end

FactoryGirl.sequence :email do |n|
  "person-#{n}@example.com"
end

FactoryGirl.define do
  factory :briefingpost do
    bp.content "Foo bar"
    bp.association :user
  end
end