# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Routing.delete_all
Passenger.delete_all
Routing.create(:routing => 'SGN-HAN', :destination => 'HANOI', :is_domestic => true)
Routing.create(:routing => 'SGN-DAD', :destination => 'DA NANG', :is_domestic => true)
Routing.create(:routing => 'SGN-MEL', :destination => 'MELBOURNE-AUSTRALIA', :is_domestic => false)
