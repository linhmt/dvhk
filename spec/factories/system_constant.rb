require 'factory_girl'

FactoryGirl.define do
  factory :system_constant do
    name "valid_position"
    value ["PK1","GT1"]
  end
end