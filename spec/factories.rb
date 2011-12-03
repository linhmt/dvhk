require 'factory_girl'

Factory.define :user do |u|
  u.name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
end

Factory.define :priority do |pri|
  pri.description 'PLATIUM VNA'
  pri.pri_level 1
  pri.pri_name 'PLA'
end