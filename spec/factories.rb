require 'factory_girl'

Factory.define :user do |u|
  u.name 'Test User Fullname'
  u.short_name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
end

Factory.define :priority do |pri|
  pri.description 'PLATIUM VNA'
  pri.pri_level 1
  pri.pri_name 'PLA'
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :briefingpost do |bp|
  bp.content "Foo bar"
  bp.association :user
end